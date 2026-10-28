//
//  ServicioDao.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import Foundation
import Combine
import SQLite3

protocol ServicioDao {
    func obtenerTodos() -> AnyPublisher<[ServicioEntity], Never>
    func insertar(_ servicio: ServicioEntity)
    func eliminar(_ servicio: ServicioEntity)
}

final class ServicioDaoImpl: ServicioDao {
    private let db: OpaquePointer?
    private let queue: DispatchQueue
    private let sujetoServicios = CurrentValueSubject<[ServicioEntity], Never>([])
    private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    init(db: OpaquePointer?, queue: DispatchQueue) {
        self.db = db
        self.queue = queue
        recargarServicios()
    }

    func obtenerTodos() -> AnyPublisher<[ServicioEntity], Never> {
        return sujetoServicios
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func insertar(_ servicio: ServicioEntity) {
        queue.async { [weak self] in
            guard let self = self, let db = self.db else { return }
            let sql = "INSERT INTO servicios (nombre, tipo, monto, vencimientoMillis, pagado) VALUES (?, ?, ?, ?, ?);"
            var statement: OpaquePointer?

            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, (servicio.nombre as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 2, (servicio.tipo as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                sqlite3_bind_int64(statement, 3, servicio.monto)
                sqlite3_bind_int64(statement, 4, servicio.vencimientoMillis)
                sqlite3_bind_int(statement, 5, servicio.pagado ? 1 : 0)

                if sqlite3_step(statement) != SQLITE_DONE {
                    print("ServicioDao: Error al insertar servicio")
                }
            }
            sqlite3_finalize(statement)
            self.recargarServiciosInterno()
        }
    }

    func eliminar(_ servicio: ServicioEntity) {
        queue.async { [weak self] in
            guard let self = self, let db = self.db else { return }
            let sql = "DELETE FROM servicios WHERE id = ?;"
            var statement: OpaquePointer?

            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int64(statement, 1, servicio.id)
                if sqlite3_step(statement) != SQLITE_DONE {
                    print("ServicioDao: Error al eliminar servicio")
                }
            }
            sqlite3_finalize(statement)
            self.recargarServiciosInterno()
        }
    }

    private func recargarServicios() {
        queue.async { [weak self] in
            self?.recargarServiciosInterno()
        }
    }

    private func recargarServiciosInterno() {
        guard let db = db else { return }
        let sql = "SELECT id, nombre, tipo, monto, vencimientoMillis, pagado FROM servicios ORDER BY vencimientoMillis ASC;"
        var statement: OpaquePointer?
        var lista: [ServicioEntity] = []

        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let nombre = sqlite3_column_text(statement, 1).map { String(cString: $0) } ?? ""
                let tipo = sqlite3_column_text(statement, 2).map { String(cString: $0) } ?? ""
                let monto = sqlite3_column_int64(statement, 3)
                let vencimientoMillis = sqlite3_column_int64(statement, 4)
                let pagado = sqlite3_column_int(statement, 5) != 0

                lista.append(
                    ServicioEntity(
                        id: id,
                        nombre: nombre,
                        tipo: tipo,
                        monto: monto,
                        vencimientoMillis: vencimientoMillis,
                        pagado: pagado
                    )
                )
            }
        }
        sqlite3_finalize(statement)
        sujetoServicios.send(lista)
    }
}
