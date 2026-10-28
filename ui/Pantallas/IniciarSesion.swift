import SwiftUI

struct IniciarSesion: View {
    var onLoginExitoso: () -> Void = {}
    var onIrARegistro: () -> Void = {}
    var onOlvidoPassword: () -> Void = {}
    @State private var identificador = ""
    @State private var password = ""
    @State private var error = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Iniciar Sesión").font(.title.bold()).foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 14) {
                Text("Ingresa tus Datos").font(.headline).foregroundStyle(.white)
                CampoOscuro(titulo: "Correo o Nombre de Usuario", texto: $identificador)
                CampoOscuro(titulo: "Contraseña", texto: $password, seguro: true)
                if !error.isEmpty { Text(error).font(.footnote).foregroundStyle(.red) }
                BotonPrincipal(titulo: "Iniciar Sesión") {
                    guard !identificador.isEmpty && !password.isEmpty else {
                        error = "Por favor completa todos los campos"; return
                    }
                    // Aquí se conecta la autenticación real del proyecto.
                    error = ""
                    onLoginExitoso()
                }
                Button("¿Olvidaste tu contraseña?", action: onOlvidoPassword)
                    .foregroundStyle(turquesa).frame(maxWidth: .infinity)
            }.padding(20).background(tarjeta).clipShape(RoundedRectangle(cornerRadius: 20))
            Button("Crear Cuenta", action: onIrARegistro).foregroundStyle(.white)
            Spacer()
        }.padding(24).frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(fondo.ignoresSafeArea())
    }
}
