import SwiftUI

struct Inicio: View {
    var nombreUsuario = "Usuario"
    @Binding var servicios: [Servicio]
    @Binding var historial: [Pago]
    var accionPerfil: () -> Void = {}
    @State private var seleccion = "Inicio"

    var totalPendiente: Double { servicios.reduce(0) { $0 + $1.monto } }
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Hola, \\(nombreUsuario)").font(.title2.bold()).foregroundStyle(.white)
                        Spacer()
                        Button(action: accionPerfil) {
                            Image(systemName: "person.crop.circle.fill").font(.system(size: 34)).foregroundStyle(turquesa)
                        }
                    }
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Resumen del Mes").font(.headline.bold()).foregroundStyle(.white)
                        HStack {
                            VStack {
                                Text("Total Pendiente:").font(.caption).foregroundStyle(.gray)
                                Text(totalPendiente, format: .currency(code: "COP").precision(.fractionLength(0)))
                                    .fontWeight(.bold).foregroundStyle(.white)
                            }
                            Spacer()
                            VStack {
                                Text("Pagos Realizados:").font(.caption).foregroundStyle(.gray)
                                Text("\\(historial.count)").fontWeight(.bold).foregroundStyle(.white)
                            }
                        }
                        HStack(alignment: .bottom, spacing: 14) {
                            barra("Julio", 0.65); barra("Agosto", 0.42); barra("Septiembre", 0.85); barra("Octubre", 0.32)
                        }.frame(height: 130)
                    }.padding(18).frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 0.08, green: 0.08, blue: 0.08)).clipShape(RoundedRectangle(cornerRadius: 18))
                    Text("PRÓXIMOS VENCIMIENTOS").font(.caption.bold()).foregroundStyle(.white)
                    ForEach(servicios.sorted { $0.vencimiento < $1.vencimiento }.prefix(3)) { servicio in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(servicio.nombre).fontWeight(.bold).foregroundStyle(.white)
                                Text(servicio.vencimiento.formatted(date: .abbreviated, time: .omitted)).font(.caption).foregroundStyle(.gray)
                            }
                            Spacer()
                            Text(servicio.monto, format: .currency(code: "COP").precision(.fractionLength(0))).foregroundStyle(.white)
                        }.padding(14).background(tarjeta).clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }.padding(20)
            }
            BarraInferior(seleccion: $seleccion)
        }.background(fondo.ignoresSafeArea())
    }
    func barra(_ titulo: String, _ altura: CGFloat) -> some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 5).fill(turquesa).frame(height: 100 * altura)
            Text(titulo).font(.caption2).foregroundStyle(.gray)
        }.frame(maxWidth: .infinity)
    }
}
