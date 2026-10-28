import SwiftUI

struct Pagos: View {
    @Binding var historial: [PagoEntity]
    var accionNavegacion: (String) -> Void = { _ in }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Historial de Pagos").font(.title2.bold()).foregroundStyle(.white).padding(.bottom, 12)
            if historial.isEmpty {
                Spacer()
                Text("Todavía no has realizado ningún pago.\nVe a “Mis Servicios” y paga una factura para verla aquí.")
                    .foregroundStyle(.gray).multilineTextAlignment(.center)
                Spacer()
            } else {
                List(historial) { pago in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(pago.servicio).fontWeight(.bold).foregroundStyle(.white)
                            Spacer()
                            Text(pago.estado).font(.caption.bold()).foregroundStyle(.white)
                                .padding(7).background(Color.green.opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Text("Fecha: \(pago.fecha)").font(.caption).foregroundStyle(.gray)
                        Text(pago.monto).fontWeight(.bold).foregroundStyle(verdePago)
                    }.padding(8).listRowBackground(tarjeta)
                }.scrollContentBackground(.hidden)
            }
        }.padding(16).background(fondo.ignoresSafeArea())
    }
}
