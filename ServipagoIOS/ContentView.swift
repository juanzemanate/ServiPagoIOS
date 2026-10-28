//
//  ContentView.swift
//  Servipago
//
//  Created by MAC17 on 26/10/26.
//

/*import SwiftUI

struct ContentView: View {
    @Binding var servicios: [Servicio]
    @Binding var historial: [Pago]
    @State private var pantalla = "Bienvenida"

    var body: some View {
        Group {
            switch pantalla {
            case "Bienvenida":
                Bienvenida(accionIniciarSesion: { pantalla = "IniciarSesion" },
                           accionCrearCuenta: { pantalla = "CrearCuenta" })
            case "IniciarSesion":
                IniciarSesion(onLoginExitoso: { pantalla = "Inicio" },
                              onIrARegistro: { pantalla = "CrearCuenta" },
                              onOlvidoPassword: { pantalla = "OlvidoPassword" })
            case "CrearCuenta":
                CrearCuenta(accionIniciarSesion: { pantalla = "IniciarSesion" },
                            accionRegistroExitoso: { pantalla = "Inicio" })
            case "OlvidoPassword":
                OlvidoPassword(accionVolverLogin: { pantalla = "IniciarSesion" })
            case "Inicio":
                Inicio(servicios: $servicios, historial: $historial,
                       accionPerfil: { pantalla = "Perfil" })
            case "Servicios":
                MisServicios(servicios: $servicios, historial: $historial,
                             accionNavegacion: { pantalla = $0 })
            case "Pagos":
                Pagos(historial: $historial, accionNavegacion: { pantalla = $0 })
            case "Ajustes":
                Ajustes(accionNavegacion: { pantalla = $0 })
            case "Perfil":
                Perfil(onCerrarSesion: { pantalla = "Bienvenida" },
                       onIrACreditos: { pantalla = "Creditos" })
            case "Creditos":
                Creditos(accionVolver: { pantalla = "Perfil" })
            default:
                Bienvenida(accionIniciarSesion: { pantalla = "IniciarSesion" },
                           accionCrearCuenta: { pantalla = "CrearCuenta" })
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView(
        servicios: .constant([]),
        historial: .constant([])
    )
}*/
