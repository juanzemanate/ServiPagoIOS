//
//  Bienvenida.swift
//  ServipagoIOS
//

import SwiftUI

struct Bienvenida: View {
    var accion: () -> Void
    var accionCrear: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            HStack(spacing: 10) {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.cyan)
                Text("SERVIPAGO")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Image(systemName: "iphone.gen3")
                .font(.system(size: 115))
                .foregroundStyle(.cyan)
                .frame(height: 180)
            
            Text("¡BIENVENIDOS A\nSERVIPAGO!")
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            Text("Tus facturas, bajo control y sin cortes.")
                .font(.system(size: 14))
                .foregroundStyle(.gray)
            
            Button(action: accion) {
                Text("Iniciar Sesión")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            
            Button(action: accionCrear) {
                Text("Crear Cuenta")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .underline()
            }
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}
