//
//  UsuarioDao.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import Foundation
import SQLite3

protocol UsuarioDao {
    func registrarUsuario(_ usuario: UsuarioEntity) async
    func login(identifier: String, password: String) async -> UsuarioEntity?
    func obtenerPorEmail(_ email: String) async -> UsuarioEntity?
}

final class UsuarioDaoImpl: UsuarioDao {
    private let db: OpaquePointer?
    private let queue: DispatchQueue
    private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    init(db: OpaquePointer?, queue: DispatchQueue) {
        self.db = db
        self.queue = queue
    }

    func registrarUsuario(_ usuario: UsuarioEntity) async {
        await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                guard let self = self, let db = self.db else {
                    continuation.resume()
                    return
                }
                let sql = "INSERT INTO usuarios (nombre, email, password, telefono, ciudad) VALUES (?, ?, ?, ?, ?);"
                var statement: OpaquePointer?

                if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_text(statement, 1, (usuario.nombre as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                    sqlite3_bind_text(statement, 2, (usuario.email as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                    sqlite3_bind_text(statement, 3, (usuario.password as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                    sqlite3_bind_text(statement, 4, (usuario.telefono as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                    sqlite3_bind_text(statement, 5, (usuario.ciudad as NSString).utf8String, -1, self.SQLITE_TRANSIENT)

                    if sqlite3_step(statement) != SQLITE_DONE {
                        print("UsuarioDao: Error al registrar usuario")
                    }
                }
                sqlite3_finalize(statement)
                continuation.resume()
            }
        }
    }

    func login(identifier: String, password: String) async -> UsuarioEntity? {
        await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                guard let self = self, let db = self.db else {
                    continuation.resume(returning: nil)
                    return
                }
                let sql = "SELECT id, nombre, email, password, telefono, ciudad FROM usuarios WHERE (email = ? OR nombre = ?) AND password = ? LIMIT 1;"
                var statement: OpaquePointer?
                var usuarioEncontrado: UsuarioEntity?

                if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_text(statement, 1, (identifier as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                    sqlite3_bind_text(statement, 2, (identifier as NSString).utf8String, -1, self.SQLITE_TRANSIENT)
                    sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1, self.SQLITE_TRANSIENT)

                    if sqlite3_step(statement) == SQLITE_ROW {
                        usuarioEncontrado = self.mapearUsuario(statement: statement)
                    }
                }
                sqlite3_finalize(statement)
                continuation.resume(returning: usuarioEncontrado)
            }
        }
    }

    func obtenerPorEmail(_ email: String) async -> UsuarioEntity? {
        await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                guard let self = self, let db = self.db else {
                    continuation.resume(returning: nil)
                    return
                }
                let sql = "SELECT id, nombre, email, password, telefono, ciudad FROM usuarios WHERE email = ? LIMIT 1;"
                var statement: OpaquePointer?
                var usuarioEncontrado: UsuarioEntity?

                if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, self.SQLITE_TRANSIENT)

                    if sqlite3_step(statement) == SQLITE_ROW {
                        usuarioEncontrado = self.mapearUsuario(statement: statement)
                    }
                }
                sqlite3_finalize(statement)
                continuation.resume(returning: usuarioEncontrado)
            }
        }
    }

    private func mapearUsuario(statement: OpaquePointer?) -> UsuarioEntity {
        let id = sqlite3_column_int64(statement, 0)
        let nombre = sqlite3_column_text(statement, 1).map { String(cString: $0) } ?? ""
        let email = sqlite3_column_text(statement, 2).map { String(cString: $0) } ?? ""
        let password = sqlite3_column_text(statement, 3).map { String(cString: $0) } ?? ""
        let telefono = sqlite3_column_text(statement, 4).map { String(cString: $0) } ?? "+57 310 123 4567"
        let ciudad = sqlite3_column_text(statement, 5).map { String(cString: $0) } ?? "Popayán, Cauca"

        return UsuarioEntity(
            id: id,
            nombre: nombre,
            email: email,
            password: password,
            telefono: telefono,
            ciudad: ciudad
        )
    }
}
