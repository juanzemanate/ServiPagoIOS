import SwiftUI

struct Bienvenida: View {
    var accionIniciarSesion: () -> Void = {}
    var accionCrearCuenta: () -> Void = {}
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            HStack(spacing: 10) {
                Image(systemName: "creditcard.fill").font(.system(size: 42)).foregroundStyle(turquesa)
                Text("SERVIPAGO").font(.system(size: 30, weight: .bold)).foregroundStyle(.white)
            }
            Image(systemName: "iphone.gen3").font(.system(size: 115)).foregroundStyle(turquesa)
                .frame(height: 180)
            Text("¡BIENVENIDOS A\nSERVIPAGO!").font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center).foregroundStyle(.white)
            Text("Tus facturas, bajo control y sin cortes.")
                .font(.system(size: 14)).foregroundStyle(.gray)
            BotonPrincipal(titulo: "Iniciar Sesión", accion: accionIniciarSesion)
            Button("Crear Cuenta", action: accionCrearCuenta)
                .foregroundStyle(.white).underline()
            Spacer()
        }
        .padding(24).frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(fondo.ignoresSafeArea())
    }
}
