//
//  NubeRepositorio.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import Foundation
#if canImport(FirebaseCore) && canImport(FirebaseFirestore)
import FirebaseCore
import FirebaseFirestore
#endif

/// Base de datos REMOTA de la app: Firebase Firestore (en la nube).
enum NubeRepositorio {

    private static let TAG = "NubeRepositorio"

    /// Sube un servicio a la colección "servicios".
    static func subirServicio(_ servicio: ServicioEntity) {
        let creadoEn = Int64(Date().timeIntervalSince1970 * 1000)
        let datos: [String: Any] = [
            "nombre": servicio.nombre,
            "tipo": servicio.tipo,
            "monto": servicio.monto,
            "vencimientoMillis": servicio.vencimientoMillis,
            "creadoEn": creadoEn
        ]

        #if canImport(FirebaseCore) && canImport(FirebaseFirestore)
        guard FirebaseApp.app() != nil else {
            print("[\(TAG)] Firebase no está configurado (falta GoogleService-Info.plist): el servicio solo quedó en la base de datos local")
            return
        }
        Firestore.firestore().collection("servicios").addDocument(data: datos) { error in
            if let error = error {
                print("[\(TAG)] Error subiendo el servicio a Firestore: \(error.localizedDescription)")
            } else {
                print("[\(TAG)] Servicio subido a Firestore correctamente")
            }
        }
        #else
        print("[\(TAG)] SDK de Firebase no instalado aún: el servicio '\(servicio.nombre)' solo quedó guardado localmente (\(datos.count) campos)")
        #endif
    }

    /// Sube un pago a la colección "pagos".
    static func subirPago(_ pago: PagoEntity) {
        let creadoEn = Int64(Date().timeIntervalSince1970 * 1000)
        let datos: [String: Any] = [
            "servicio": pago.servicio,
            "monto": pago.monto,
            "fecha": pago.fecha,
            "estado": pago.estado,
            "creadoEn": creadoEn
        ]

        #if canImport(FirebaseCore) && canImport(FirebaseFirestore)
        guard FirebaseApp.app() != nil else {
            print("[\(TAG)] Firebase no está configurado (falta GoogleService-Info.plist): el pago solo quedó en la base de datos local")
            return
        }
        Firestore.firestore().collection("pagos").addDocument(data: datos) { error in
            if let error = error {
                print("[\(TAG)] Error subiendo el pago a Firestore: \(error.localizedDescription)")
            } else {
                print("[\(TAG)] Pago subido a Firestore correctamente")
            }
        }
        #else
        print("[\(TAG)] SDK de Firebase no instalado aún: el pago de '\(pago.servicio)' solo quedó guardado localmente (\(datos.count) campos)")
        #endif
    }

    /// Sube o actualiza un usuario en la colección "usuarios".
    static func subirUsuario(usuarioId: String, datosUsuario: [String: Any]) {
        #if canImport(FirebaseCore) && canImport(FirebaseFirestore)
        guard FirebaseApp.app() != nil else {
            print("[\(TAG)] Firebase no está configurado: el usuario solo quedó en la base de datos local")
            return
        }
        Firestore.firestore().collection("usuarios").document(usuarioId).setData(datosUsuario) { error in
            if let error = error {
                print("[\(TAG)] Error subiendo el usuario a Firestore: \(error.localizedDescription)")
            } else {
                print("[\(TAG)] Usuario subido a Firestore correctamente: \(usuarioId)")
            }
        }
        #else
        print("[\(TAG)] SDK de Firebase no instalado aún: el usuario '\(usuarioId)' solo quedó guardado localmente")
        #endif
    }
}
