//
//  SesionUsuario.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import SwiftUI
import UIKit
import Combine

/// Objeto global reactivo para mantener en memoria los datos del usuario que acaba de iniciar sesión.
final class SesionUsuario: ObservableObject {
    static let shared = SesionUsuario()

    @Published var nombre: String = "Usuario"
    @Published var email: String = "correo@ejemplo.com"
    @Published var telefono: String = "+57 310 123 4567"
    @Published var ciudad: String = "Popayán, Cauca"

    // Estado reactivo para la foto de perfil (UIImage equivale a Bitmap en iOS)
    @Published var fotoPerfil: UIImage? = nil

    private init() {}

    func iniciar(usuario: UsuarioEntity) {
        DispatchQueue.main.async {
            self.nombre = usuario.nombre
            self.email = usuario.email
            self.telefono = usuario.telefono
            self.ciudad = usuario.ciudad
        }
    }

    func cerrar() {
        DispatchQueue.main.async {
            self.nombre = "Usuario"
            self.email = "correo@ejemplo.com"
            self.telefono = "+57 310 123 4567"
            self.ciudad = "Popayán, Cauca"
            self.fotoPerfil = nil
        }
    }
}
