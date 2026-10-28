//
//  UsuarioEntity.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import Foundation

/// Tabla de usuarios para el registro y el inicio de sesión local.
struct UsuarioEntity: Identifiable, Codable, Equatable {
    var id: Int64 = 0
    let nombre: String
    let email: String
    let password: String
    var telefono: String = "+57 310 123 4567"
    var ciudad: String = "Popayán, Cauca"
}
