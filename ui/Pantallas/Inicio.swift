import SwiftUI

struct Inicio: View {
    var nombreUsuario = "Usuario"
    @Binding var servicios: [ServicioEntity] // <-- Cambia [Servicio] por [ServicioEntity]
    @Binding var historial: [PagoEntity]    // <-- Cambia [Pago] por [PagoEntity]
    var accionPerfil: () -> Void = {}
    @State private var seleccion = "Inicio"

    // Calculamos el total pendiente usando la propiedad 'monto' (Int64) de ServicioEntity
    var totalPendiente: Double {
        servicios.filter { !$0.pagado }.reduce(0) { $0 + Double($1.monto) }
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Hola, \(nombreUsuario)")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        Spacer()
                        Button(action: accionPerfil) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 34))
                                .foregroundStyle(.cyan)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Resumen del Mes")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total Pendiente:")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text(totalPendiente, format: .currency(code: "COP").precision(.fractionLength(0)))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Pagos Realizados:")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text("\(historial.count)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        HStack(alignment: .bottom, spacing: 14) {
                            barra("Julio", 0.65)
                            barra("Agosto", 0.42)
                            barra("Septiembre", 0.85)
                            barra("Octubre", 0.32)
                        }
                        .frame(height: 130)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    Text("PRÓXIMOS VENCIMIENTOS")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                    
                    ForEach(servicios.sorted { $0.vencimientoMillis < $1.vencimientoMillis }.prefix(3)) { servicio in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(servicio.nombre)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                // Convertimos vencimientoMillis a Date legible
                                Text(Date(timeIntervalSince1970: Double(servicio.vencimientoMillis) / 1000), format: .dateTime.day().month().year())
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Text(Double(servicio.monto), format: .currency(code: "COP").precision(.fractionLength(0)))
                                .foregroundStyle(.white)
                        }
                        .padding(14)
                        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(20)
            }
            
            // BarraInferior(seleccion: $seleccion) // Descomenta si ya tienes este componente creado
        }
        .background(Color.black.ignoresSafeArea())
    }

    func barra(_ titulo: String, _ altura: CGFloat) -> some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.cyan)
                .frame(height: 100 * altura)
            Text(titulo)
                .font(.caption2)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
