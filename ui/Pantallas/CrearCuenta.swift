import SwiftUI

struct CrearCuenta: View {
    var accionIniciarSesion: () -> Void = {}
    var accionRegistroExitoso: () -> Void = {}
    @State private var nombre = ""
    @State private var email = ""
    @State private var contrasena = ""
    @State private var confirmar = ""
    @State private var aceptaTerminos = false
    @State private var error = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Text("Crear Cuenta").font(.title.bold()).foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 14) {
                    Text("Ingresa tus Datos").font(.headline).foregroundStyle(.white)
                    CampoOscuro(titulo: "Nombre", texto: $nombre)
                    CampoOscuro(titulo: "Email", texto: $email)
                    CampoOscuro(titulo: "Contraseña", texto: $contrasena, seguro: true)
                    CampoOscuro(titulo: "Confirmar contraseña", texto: $confirmar, seguro: true)
                    Toggle("Acepto los términos y condiciones", isOn: $aceptaTerminos)
                        .tint(turquesa).foregroundStyle(.white)
                    if !error.isEmpty { Text(error).foregroundStyle(.red).font(.footnote) }
                    BotonPrincipal(titulo: "Crear Cuenta") {
                        if nombre.isEmpty || email.isEmpty || contrasena.isEmpty || confirmar.isEmpty {
                            error = "Por favor completa todos los campos"
                        } else if contrasena != confirmar {
                            error = "Las contraseñas no coinciden"
                        } else if !aceptaTerminos {
                            error = "Debes aceptar los términos y condiciones"
                        } else {
                            error = ""
                            accionRegistroExitoso()
                        }
                    }
                }
                .padding(20).background(tarjeta).clipShape(RoundedRectangle(cornerRadius: 20))
                Button("¿Ya tienes cuenta? Iniciar sesión", action: accionIniciarSesion)
                    .foregroundStyle(turquesa)
            }.padding(24)
        }.background(fondo.ignoresSafeArea())
    }
}
