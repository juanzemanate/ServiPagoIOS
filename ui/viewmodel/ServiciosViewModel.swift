//
//  ServiciosViewModel.swift
//  ServipagoIOS
//
//  Created by MAC16 on 28/10/26.
//
import Foundation
import Combine


final class ServiciosViewModel: ObservableObject {


    // Lista observable de servicios guardados.
    @Published var servicios: [ServicioEntity] = []


    // Agrega un servicio a la lista.
    func agregarServicio(_ servicio: ServicioEntity) {
        servicios.append(servicio)
    }


    // Elimina un servicio de la lista.
    func eliminarServicio(_ servicio: ServicioEntity) {
        servicios.removeAll { $0.id == servicio.id }
    }
}
