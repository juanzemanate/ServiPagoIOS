//
//  AppNavegacion.swift
//  ServipagoIOS
//
//  Created by MAC16 on 28/10/26.
//

import SwiftUI


enum RutaApp: Hashable {
    case bienvenida
    case iniciarSesion
    case crearCuenta
    case olvidoPassword
    case inicio
    case misServicios
    case pagos
    case ajustes
    case perfil
    case creditos
}


struct AppNavegacion: View {
    @State private var rutaActual: RutaApp = .bienvenida
    @State private var mostrarMensaje = false
    @State private var mensaje = ""


    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()


            Group {
                switch rutaActual {
                case .bienvenida:
                    Bienvenidaview(
                        accion: {
                            navegar(.iniciarSesion)
                        },
                        accionCrear: {
                            navegar(.crearCuenta)
                        }
                    )


                case .iniciarSesion:
                    IniciarSesionView(
                        onLoginExitoso: {
                            navegar(.inicio, limpiarHistorial: true)
                        },
                        onIrARegistro: {
                            navegar(.crearCuenta)
                        }
                    )


                case .crearCuenta:
                    CrearCuentaView(
                        accionIniciarSesion: {
                            navegar(.iniciarSesion)
                        },
                        accionRegistroExitoso: {
                            mensaje = "Cuenta creada exitosamente"
                            mostrarMensaje = true
                            navegar(.bienvenida, limpiarHistorial: true)
                        }
                    )


                case .olvidoPassword:
                    OlvidoPasswordView(
                        accionVolverLogin: {
                            navegar(.iniciarSesion)
                        }
                    )


                case .inicio:
                    InicioView(
                        accionServicioAgregado: { nombre in
                            mensaje = "Servicio \(nombre) agregado"
                            mostrarMensaje = true
                        },
                        accionInicio: {},
                        accionServicios: {
                            navegar(.misServicios)
                        },
                        accionPagos: {
                            navegar(.pagos)
                        },
                        accionAjustes: {
                            navegar(.ajustes)
                        },
                        accionPerfil: {
                            navegar(.perfil)
                        }
                    )


                case .misServicios:
                    MisServiciosView(
                        accionInicio: {
                            navegar(.inicio)
                        },
                        accionPagos: {
                            navegar(.pagos)
                        },
                        accionAjustes: {
                            navegar(.ajustes)
                        }
                    )


                case .pagos:
                    PagosView(
                        accionInicio: {
                            navegar(.inicio)
                        },
                        accionServicios: {
                            navegar(.misServicios)
                        },
                        accionAjustes: {
                            navegar(.ajustes)
                        }
                    )


                case .ajustes:
                    AjustesView(
                        accionInicio: {
                            navegar(.inicio)
                        },
                        accionServicios: {
                            navegar(.misServicios)
                        },
                        accionPagos: {
                            navegar(.pagos)
                        }
                    )


                case .perfil:
                    PerfilView(
                        onCerrarSesion: {
                            navegar(.bienvenida, limpiarHistorial: true)
                        },
                        onIrACreditos: {
                            navegar(.creditos)
                        }
                    )


                case .creditos:
                    CreditosView(
                        accionVolver: {
                            navegar(.perfil)
                        }
                    )
                }
            }
        }
        .overlay(alignment: .top) {
            if mostrarMensaje {
                Text(mensaje)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top, 12)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 2.5
                        ) {
                            mostrarMensaje = false
                        }
                    }
            }
        }
    }


    private func navegar(
        _ destino: RutaApp,
        limpiarHistorial: Bool = false
    ) {
        // En esta versión sencilla, cambiar la ruta reemplaza
        // la pantalla actual. Limpiar el historial no requiere
        // una operación adicional.
        rutaActual = destino
    }
}


#Preview {
    AppNavegacion()
}
