import SwiftUI
import UIKit


/// Barra de navegación inferior reutilizada en varias pantallas.
enum PantallaInferior {
    case INICIO
    case SERVICIOS
    case PAGOS
    case AJUSTES
}


struct BarraNavegacionInferior: View {
    var pantallaActual: PantallaInferior


    var accionInicio: () -> Void
    var accionServicios: () -> Void
    var accionPagos: () -> Void
    var accionAjustes: () -> Void


    private let colorAcento = Color(
        red: 41.0 / 255.0,
        green: 217.0 / 255.0,
        blue: 232.0 / 255.0
    )


    private let colorFondo = Color(
        red: 58.0 / 255.0,
        green: 58.0 / 255.0,
        blue: 58.0 / 255.0
    )


    var body: some View {
        HStack(spacing: 0) {
            ItemNavegacion(
                icono: "casa_logo",
                simbolo: "house.fill",
                etiqueta: "Inicio",
                activo: pantallaActual == .INICIO,
                accion: accionInicio
            )


            ItemNavegacion(
                icono: "servicios_logo",
                simbolo: "list.bullet.rectangle",
                etiqueta: "Mis Servicios",
                activo: pantallaActual == .SERVICIOS,
                accion: accionServicios
            )


            ItemNavegacion(
                icono: "billetera_logo",
                simbolo: "wallet.pass.fill",
                etiqueta: "Pagos",
                activo: pantallaActual == .PAGOS,
                accion: accionPagos
            )


            ItemNavegacion(
                icono: "configuracion_logo",
                simbolo: "gearshape.fill",
                etiqueta: "Ajustes",
                activo: pantallaActual == .AJUSTES,
                accion: accionAjustes
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(colorFondo)
    }
}


private struct ItemNavegacion: View {
    let icono: String
    let simbolo: String
    let etiqueta: String
    let activo: Bool
    let accion: () -> Void


    private let colorAcento = Color(
        red: 41.0 / 255.0,
        green: 217.0 / 255.0,
        blue: 232.0 / 255.0
    )


    var body: some View {
        Button(action: accion) {
            VStack(spacing: 2) {
                Group {
                    if let imagen = UIImage(named: icono) {
                        Image(uiImage: imagen)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: simbolo)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 20, height: 20)


                Text(etiqueta)
                    .font(.system(size: 10))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(
                activo
                ? colorAcento
                : Color(red: 0.83, green: 0.83, blue: 0.83)
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
