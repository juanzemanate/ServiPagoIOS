import SwiftUI

struct OlvidoPassword: View {
    var accionVolverLogin: () -> Void = {}
    @State private var email = ""
    @State private var enviado = false
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: accionVolverLogin) { Image(systemName: "arrow.left").foregroundStyle(.white) }
                Spacer()
            }
            Text("Recuperar Contraseña").font(.title2.bold()).foregroundStyle(.white)
            VStack(spacing: 16) {
                if enviado {
                    Text("¡Correo enviado con éxito! Revisa tu bandeja de entrada para restablecer tu contraseña.")
                        .foregroundStyle(verdePago).multilineTextAlignment(.center)
                    BotonPrincipal(titulo: "Volver al Login", accion: accionVolverLogin)
                } else {
                    Text("Ingresa tu correo electrónico registrado y te enviaremos las instrucciones.")
                        .foregroundStyle(.gray).multilineTextAlignment(.center)
                    CampoOscuro(titulo: "Correo electrónico", texto: $email)
                    BotonPrincipal(titulo: "Enviar Instrucciones") {
                        if !email.isEmpty { enviado = true }
                    }
                }
            }.padding(20).background(tarjeta).clipShape(RoundedRectangle(cornerRadius: 20))
            Spacer()
        }.padding(24).background(fondo.ignoresSafeArea())
    }
}
