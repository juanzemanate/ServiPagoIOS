//
//  ServipagoIOSApp.swift
//  ServipagoIOS
//
//  Created by MAC17 on 27/10/26.
//

import SwiftUI

@main
struct ServiPagoApp: App {
    @State private var servicios: [Servicio] = []
    @State private var historial: [Pago] = []
    var body: some Scene {
        WindowGroup {
            ContentView(servicios: $servicios, historial: $historial)
        }
    }
}
