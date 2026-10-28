import SwiftUI

struct Creditos: View {
    var accionVolver: () -> Void = {}
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Button(action: accionVolver) { Image(systemName: "arrow.left").foregroundStyle(.white) }
                    Text("Acerca de ServiPago").font(.headline.bold()).foregroundStyle(.white)
                    Spacer()
                }
                Spacer(minLength: 8)
                Text("Descripción de la Aplicación").font(.headline.bold()).foregroundStyle(turquesa)
                Text("ServiPago es una solución móvil diseñada para centralizar el control y pago oportuno de los servicios públicos esenciales (agua, gas, electricidad) y telecomunicaciones, evitando cortes y optimizando las finanzas del hogar.")
                    .foregroundStyle(.white).multilineTextAlignment(.center)
                Text("Créditos y Estudiantes").font(.headline.bold()).foregroundStyle(turquesa)
                Text("Desarrollado por:").fontWeight(.bold).foregroundStyle(.white)
                Text("• Yury Yasmin Daza Perez\n• Juan Felipe Vivas\n• Juan Jose Zemanate\n• Estudiante Electiva Desarrollo de Aplicaciones Móviles")
                    .foregroundStyle(.white).multilineTextAlignment(.center)
                Text("Universidad del Cauca\nFacultad de Ingeniería Electrónica y Telecomunicaciones")
                    .fontWeight(.bold).foregroundStyle(.white).multilineTextAlignment(.center)
            }.padding(24)
        }.background(fondo.ignoresSafeArea())
    }
}
