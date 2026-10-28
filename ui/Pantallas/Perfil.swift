import SwiftUI
import PhotosUI

struct Perfil: View {
    @AppStorage("nombreUsuario") private var nombreUsuario = "Usuario"
    @AppStorage("emailUsuario") private var emailUsuario = "correo@ejemplo.com"
    @AppStorage("telefonoUsuario") private var telefonoUsuario = "No registrado"
    @AppStorage("ciudadUsuario") private var ciudadUsuario = "Popayán, Cauca"
    var onCerrarSesion: () -> Void = {}
    var onIrACreditos: () -> Void = {}
    @State private var fotoSeleccionada: PhotosPickerItem?
    @State private var imagen: Image?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Mi Perfil").font(.title2.bold()).foregroundStyle(.white)
                PhotosPicker(selection: $fotoSeleccionada, matching: .images) {
                    Group {
                        if let imagen {
                            imagen.resizable().scaledToFill()
                        } else {
                            Text(String(nombreUsuario.prefix(1)).uppercased())
                                .font(.system(size: 32, weight: .bold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.gray.opacity(0.35))
                        }
                    }.frame(width: 88, height: 88).clipShape(Circle())
                }.onChange(of: fotoSeleccionada) { _, item in
                    Task {
                        if let data = try? await item?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) { imagen = Image(uiImage: uiImage) }
                    }
                }
                Text(nombreUsuario).font(.title3.bold()).foregroundStyle(.white)
                Text(emailUsuario).foregroundStyle(.gray)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Información de la Cuenta").font(.headline.bold()).foregroundStyle(turquesa)
                    Text("Teléfono: \\(telefonoUsuario)").foregroundStyle(.gray)
                    Text("Ciudad: \\(ciudadUsuario)").foregroundStyle(.gray)
                    Text("Método de Pago: Tarjeta **** 4321").foregroundStyle(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(16)
                    .background(tarjeta).clipShape(RoundedRectangle(cornerRadius: 16))
                Button(action: onIrACreditos) {
                    Label("Acerca de la App y Créditos", systemImage: "info.circle")
                        .frame(maxWidth: .infinity).frame(height: 48)
                }.foregroundStyle(turquesa).overlay(Capsule().stroke(.gray, lineWidth: 1))
                BotonPrincipal(titulo: "Cerrar Sesión") {
                    nombreUsuario = ""; emailUsuario = ""; telefonoUsuario = ""; ciudadUsuario = ""
                    onCerrarSesion()
                }
            }.padding(24)
        }.background(fondo.ignoresSafeArea())
    }
}
