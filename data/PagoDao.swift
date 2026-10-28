//
//  PagoDao.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import Foundation
import Combine
import SQLite3

protocol PagoDao {
    func obtenerTodos() -> AnyPublisher<[PagoEntity], Never>
    func insertar(_ pago: PagoEntity)
}

final class PagoDaoImpl: PagoDao {
    private let db: OpaquePointer?
    private let queue: DispatchQueue
    private let sujetoPagos = CurrentValueSubject<[PagoEntity], Never>([])
    private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    init(db: OpaquePointer?, queue: DispatchQueue) {
        self.db = db
        self.queue = queue
        recargarPagos()
    }

    func obtenerTodos() -> AnyPublisher<[PagoEntity], Never> {
        return sujetoPagos
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func insertar(_ pago: PagoEntity) {
        queue.async { [weak self] in
            guard let self = self, let db = self.db else { return }
            let sql = "INSERT INTO pagos (servicio, monto, fecha, estado) VALUES (?, ?, ?, ?);"
            var statement: OpaquePointer?

            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, (pago.servicio as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 2, (pago.monto as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 3, (pago.fecha as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 4, (pago.estado as NSString).utf8String, -1, self.SQLITE_TRANSIENT)

                if sqlite3_step(statement) != SQLITE_DONE {
                    print("PagoDao: Error al insertar pago")
                }
            }
            sqlite3_finalize(statement)
            self.recargarPagosInterno()
        }
    }

    private func recargarPagos() {
        queue.async { [weak self] in
            self?.recargarPagosInterno()
        }
    }

    private func recargarPagosInterno() {
        guard let db = db else { return }
        let sql = "SELECT id, servicio, monto, fecha, estado FROM pagos ORDER BY id DESC;"
        var statement: OpaquePointer?
        var lista: [PagoEntity] = []

        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let servicio = sqlite3_column_text(statement, 1).map { String(cString: $0) } ?? ""
                let monto = sqlite3_column_text(statement, 2).map { String(cString: $0) } ?? ""
                let fecha = sqlite3_column_text(statement, 3).map { String(cString: $0) } ?? ""
                let estado = sqlite3_column_text(statement, 4).map { String(cString: $0) } ?? "Pagado"

                lista.append(
                    PagoEntity(
                        id: id,
                        servicio: servicio,
                        monto: monto,
                        fecha: fecha,
                        estado: estado
                    )
                )
            }
        }
        sqlite3_finalize(statement)
        sujetoPagos.send(lista)
    }
}
