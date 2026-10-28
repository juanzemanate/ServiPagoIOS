import SwiftUI
import PhotosUI

let fondo = Color.black
let tarjeta = Color(red: 0.16, green: 0.16, blue: 0.16)
let grisCampo = Color(red: 0.29, green: 0.29, blue: 0.29)
let turquesa = Color(red: 41/255, green: 217/255, blue: 232/255)
let verdePago = Color(red: 61/255, green: 214/255, blue: 46/255)

struct BotonPrincipal: View {
    let titulo: String
    var accion: () -> Void
    var body: some View {
        Button(action: accion) {
            Text(titulo).fontWeight(.bold).foregroundStyle(.black)
                .frame(maxWidth: .infinity).frame(height: 50)
                .background(.white).clipShape(Capsule())
        }
    }
}

struct CampoOscuro: View {
    let titulo: String
    @Binding var texto: String
    var seguro = false
    var body: some View {
        Group {
            if seguro {
                SecureField(titulo, text: $texto)
            } else {
                TextField(titulo, text: $texto)
                    .textInputAutocapitalization(.never)
            }
        }
        .padding(.horizontal, 16).frame(height: 48)
        .foregroundStyle(.white).tint(turquesa)
        .background(grisCampo).clipShape(Capsule())
    }
}

struct BarraInferior: View {
    @Binding var seleccion: String
    var body: some View {
        HStack {
            item("Inicio", "house.fill")
            item("Servicios", "doc.text")
            item("Pagos", "creditcard")
            item("Ajustes", "gearshape")
        }
        .padding(.top, 12).padding(.bottom, 8)
        .background(Color.black)
    }
    func item(_ nombre: String, _ icono: String) -> some View {
        Button { seleccion = nombre } label: {
            VStack(spacing: 4) {
                Image(systemName: icono)
                Text(nombre).font(.caption2)
            }
            .foregroundStyle(seleccion == nombre ? turquesa : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}
