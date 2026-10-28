//
//  SesionViewModel.swift
//  ServipagoIOS
//
//  Created by MAC16 on 28/10/26.
//
import SwiftUI
import Combine


/// ViewModel que guarda el estado de la sesión del usuario.
/// Mantiene los datos compartidos entre las pantallas mientras
/// la instancia siga activa.


final class SesionViewModel: ObservableObject {


    @Published private(set) var nombreUsuario: String = "Sofia Daza"
    @Published private(set) var emailUsuario: String = "sofia.daza@unicauca.edu.co"
    @Published private(set) var telefonoUsuario: String = "+57 310 123 4567"
    @Published private(set) var tarjetaUsuario: String = "**** 4321"


    /// Actualiza el nombre y el correo del perfil.
    func actualizarPerfil(nombre: String, email: String) {
        nombreUsuario = nombre
        emailUsuario = email
    }
}
