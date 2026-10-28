import SwiftUI

struct MisServicios: View {
    @Binding var servicios: [ServicioEntity]
    @Binding var historial: [PagoEntity]
    @State private var mostrarAgregar = false
    @State private var nombreNuevo = ""
    @State private var tipoNuevo = "Servicios públicos"
    @State private var montoNuevo = ""
    @State private var vencimientoNuevo = Date()
    var accionNavegacion: (String) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                Text("Buscar servicio o convenio...").font(.subheadline).foregroundStyle(.gray)
                Spacer()
            }.padding(14).background(tarjeta).clipShape(Capsule())
            
            if servicios.isEmpty {
                Spacer()
                Text("No hay servicios registrados.\nToca el botón [+] para agregar uno.")
                    .foregroundStyle(.gray).multilineTextAlignment(.center)
                Spacer()
            } else {
                List {
                    ForEach(servicios) { servicio in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(servicio.nombre).fontWeight(.bold).foregroundStyle(.white)
                                    let fechaVencimiento = Date(timeIntervalSince1970: Double(servicio.vencimientoMillis) / 1000)
                                    Text("Vence: \(fechaVencimiento.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption).foregroundStyle(.gray)
                                }
                                Spacer()
                                Text(Double(servicio.monto), format: .currency(code: "COP").precision(.fractionLength(0)))
                                    .foregroundStyle(.white)
                            }
                            let fechaVencimiento = Date(timeIntervalSince1970: Double(servicio.vencimientoMillis) / 1000)
                            let dias = Calendar.current.dateComponents([.day], from: Date(), to: fechaVencimiento).day ?? 0
                            Text(dias < 0 ? "Vencido" : dias == 0 ? "Vence hoy" : dias == 1 ? "Vence mañana" : "Vence en \(dias) días")
                                .font(.caption.bold()).foregroundStyle(dias < 8 ? .red : dias <= 18 ? .orange : verdePago)
                            
                            Button("Pagar") {
                                let montoStr = Double(servicio.monto).formatted(.currency(code: "COP").precision(.fractionLength(0)))
                                let nuevoPago = PagoEntity(
                                    servicio: servicio.nombre,
                                    monto: montoStr,
                                    fecha: Date().formatted(date: .abbreviated, time: .omitted),
                                    estado: "Completado"
                                )
                                historial.insert(nuevoPago, at: 0)
                                servicios.removeAll { $0.id == servicio.id }
                            }.foregroundStyle(turquesa)
                        }.padding(10).listRowBackground(tarjeta)
                    }
                }.scrollContentBackground(.hidden)
            }
            
            Button { mostrarAgregar = true } label: {
                Image(systemName: "plus").font(.title2.bold()).foregroundStyle(.black)
                    .frame(width: 54, height: 54).background(turquesa).clipShape(Circle())
            }
        }
        .padding(.horizontal, 16).padding(.top, 16).background(fondo.ignoresSafeArea())
        .sheet(isPresented: $mostrarAgregar) {
            NavigationStack {
                Form {
                    TextField("Nombre del servicio", text: $nombreNuevo)
                    TextField("Tipo de servicio", text: $tipoNuevo)
                    TextField("Monto", text: $montoNuevo).keyboardType(.decimalPad)
                    DatePicker("Vencimiento", selection: $vencimientoNuevo, displayedComponents: .date)
                    Button("Guardar") {
                        if let montoDouble = Double(montoNuevo), !nombreNuevo.isEmpty {
                            let millis = Int64(vencimientoNuevo.timeIntervalSince1970 * 1000)
                            let nuevoServicio = ServicioEntity(
                                nombre: nombreNuevo,
                                tipo: tipoNuevo,
                                monto: Int64(montoDouble),
                                vencimientoMillis: millis,
                                pagado: false
                            )
                            servicios.append(nuevoServicio)
                            nombreNuevo = ""; montoNuevo = ""; mostrarAgregar = false
                        }
                    }
                }.navigationTitle("Nuevo servicio")
                    .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Cerrar") { mostrarAgregar = false } } }
            }
        }
    }
}
