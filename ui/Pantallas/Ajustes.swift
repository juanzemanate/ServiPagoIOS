import SwiftUI

struct Ajustes: View {
    @State private var notificaciones = true
    @State private var biometria = true
    @State private var recibosEmail = false
    @State private var seleccion = "Ajustes"
    var accionNavegacion: (String) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Ajustes del Sistema").font(.title2.bold()).foregroundStyle(.white)
                    ajuste("Notificaciones Push", detalle: "Alertas de vencimiento en pantalla", valor: $notificaciones)
                    Divider().overlay(.gray)
                    ajuste("Seguridad Biométrica", detalle: "Usar huella digital para iniciar pagos", valor: $biometria)
                    Divider().overlay(.gray)
                    ajuste("Recibos por Correo", detalle: "Enviar factura digital al pagar", valor: $recibosEmail)
                    Divider().overlay(.gray)
                    Text("Soporte y Ayuda").font(.headline.bold()).foregroundStyle(turquesa)
                    Text("• Centro de Ayuda y Preguntas Frecuentes").foregroundStyle(.gray)
                    Text("• Reportar un problema con un pago").foregroundStyle(.gray)
                    Spacer(minLength: 30)
                    Text("ServiPago App - Versión 1.0.0").font(.footnote).foregroundStyle(.gray)
                }.padding(20)
            }
            BarraInferior(seleccion: $seleccion).onChange(of: seleccion) { _, valor in accionNavegacion(valor) }
        }.background(fondo.ignoresSafeArea())
    }
    func ajuste(_ titulo: String, detalle: String, valor: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(titulo).foregroundStyle(.white)
                Text(detalle).font(.caption).foregroundStyle(.gray)
            }
            Spacer()
            Toggle("", isOn: valor).labelsHidden().tint(turquesa)
        }.padding(.vertical, 6)
    }
}
