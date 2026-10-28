//
//  AppNavegacion.swift
//  ServipagoIOS
//

import SwiftUI

struct AppNavegacion: View {
    @State private var pantallaActual: Pantallas = .Bienvenida
    @State private var historial: [Pantallas] = []
    @State private var mensaje: String?
    @State private var mostrarMensaje = false

    // Estados locales sincronizados con la base de datos local
    @State private var listaServicios: [ServicioEntity] = []
    @State private var listaPagos: [PagoEntity] = []

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            contenidoPantalla
        }
        .overlay(alignment: .top) {
            if mostrarMensaje, let mensaje = mensaje {
                Text(mensaje)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
            }
        }
    }

    @ViewBuilder
    private var contenidoPantalla: some View {
        switch pantallaActual {
        case .Bienvenida:
            Bienvenida(
                accion: { navegarA(.IniciarSesion) },
                accionCrear: { navegarA(.CrearCuenta) }
            )
            
        case .IniciarSesion:
            IniciarSesion(
                onLoginExitoso: { navegarA(.Inicio, limpiarHistorial: true) },
                onIrARegistro: { navegarA(.CrearCuenta) },
                onOlvidoPassword: { navegarA(.OlvidoPassword) }
            )
            
        case .CrearCuenta:
            CrearCuenta(
                accionIniciarSesion: { navegarA(.IniciarSesion) },
                accionRegistroExitoso: {
                    navegarA(.Bienvenida, limpiarHistorial: true)
                    mostrarAviso("Cuenta creada exitosamente")
                }
            )
            
        case .OlvidoPassword:
            OlvidoPassword(accionVolverLogin: { volver() })
            
        case .Inicio:
            Inicio(
                servicios: $listaServicios,
                historial: $listaPagos,
                accionPerfil: { navegarA(.Perfil) }
            )
            
        case .MisServicios:
            MisServicios(
                servicios: $listaServicios,
                historial: $listaPagos,
                accionNavegacion: { destino in manejarNavegacionBarra(destino) }
            )
            
        case .Pagos:
            Pagos(
                historial: $listaPagos,
                accionNavegacion: { destino in manejarNavegacionBarra(destino) }
            )
            
        case .Ajustes:
            Ajustes(
                accionNavegacion: { destino in manejarNavegacionBarra(destino) }
            )
            
        case .Perfil:
            Perfil(
                onCerrarSesion: { navegarA(.Bienvenida, limpiarHistorial: true) },
                onIrACreditos: { navegarA(.Creditos) }
            )
            
        case .Creditos:
            Creditos(accionVolver: { volver() })
        }
    }

    private func manejarNavegacionBarra(_ destino: String) {
        switch destino {
        case "Inicio":
            navegarA(.Inicio)
        case "Servicios":
            navegarA(.MisServicios)
        case "Pagos":
            navegarA(.Pagos)
        case "Ajustes":
            navegarA(.Ajustes)
        default:
            break
        }
    }

    private func navegarA(_ destino: Pantallas, limpiarHistorial: Bool = false) {
        if limpiarHistorial {
            historial.removeAll()
        } else {
            historial.append(pantallaActual)
        }
        pantallaActual = destino
    }

    private func volver() {
        guard let anterior = historial.popLast() else { return }
        pantallaActual = anterior
    }

    private func mostrarAviso(_ texto: String) {
        mensaje = texto
        mostrarMensaje = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if self.mensaje == texto { self.mostrarMensaje = false }
        }
    }
}
