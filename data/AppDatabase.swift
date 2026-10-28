//
//  AppDatabase.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import Foundation
import SQLite3

final class AppDatabase {
    static let shared = AppDatabase()

    private var db: OpaquePointer?
    private let dbQueue = DispatchQueue(label: "com.example.app_recibos.servipago_db", qos: .userInitiated)

    private lazy var pagoDaoInstance: PagoDao = PagoDaoImpl(db: db, queue: dbQueue)
    private lazy var servicioDaoInstance: ServicioDao = ServicioDaoImpl(db: db, queue: dbQueue)
    private lazy var usuarioDaoInstance: UsuarioDao = UsuarioDaoImpl(db: db, queue: dbQueue)

    private init() {
        abrirBaseDeDatos()
        crearTablasYMigraciones()
    }

    /// Equivalente a AppDatabase.getInstance(context) en Android
    static func getInstance() -> AppDatabase {
        return shared
    }

    func pagoDao() -> PagoDao {
        return pagoDaoInstance
    }

    func servicioDao() -> ServicioDao {
        return servicioDaoInstance
    }

    func usuarioDao() -> UsuarioDao {
        return usuarioDaoInstance
    }

    private func abrirBaseDeDatos() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("servipago_db.sqlite")

            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("AppDatabase: Error abriendo la base de datos servipago_db")
            }
        } catch {
            print("AppDatabase: No se pudo obtener la ruta de documentos: \(error)")
        }
    }

    private func crearTablasYMigraciones() {
        let sqlPagos = """
        CREATE TABLE IF NOT EXISTS pagos (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            servicio TEXT NOT NULL,
            monto TEXT NOT NULL,
            fecha TEXT NOT NULL,
            estado TEXT NOT NULL DEFAULT 'Pagado'
        );
        """

        // Incluye la migración 1 -> 2 y la propiedad 'pagado' de ServicioEntity
        let sqlServicios = """
        CREATE TABLE IF NOT EXISTS servicios (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nombre TEXT NOT NULL,
            tipo TEXT NOT NULL,
            monto INTEGER NOT NULL,
            vencimientoMillis INTEGER NOT NULL,
            pagado INTEGER NOT NULL DEFAULT 0
        );
        """

        // Migración 2 -> 3: Tabla "usuarios"
        let sqlUsuarios = """
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nombre TEXT NOT NULL,
            email TEXT NOT NULL,
            password TEXT NOT NULL,
            telefono TEXT NOT NULL,
            ciudad TEXT NOT NULL
        );
        """

        ejecutarSQL(sqlPagos)
        ejecutarSQL(sqlServicios)
        ejecutarSQL(sqlUsuarios)
    }

    private func ejecutarSQL(_ sql: String) {
        guard let db = db else { return }
        var errorMessage: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, sql, nil, nil, &errorMessage) != SQLITE_OK {
            if let errorMessage = errorMessage {
                let msg = String(cString: errorMessage)
                print("AppDatabase SQL Error: \(msg)")
                sqlite3_free(errorMessage)
            }
        }
    }

    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
}
