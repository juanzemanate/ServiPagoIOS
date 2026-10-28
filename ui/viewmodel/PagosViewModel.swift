//
//  PagosViewModel.swift
//  ServipagoIOS
//
//  Created by MAC16 on 28/10/26.
//
import Foundation
import Combine


final class PagosViewModel: ObservableObject {
    @Published var historialPagos: [PagoEntity] = []

    func registrarPago(
        servicio: String,
        monto: String,
        fecha: String = "Hoy"
    ) {
        let pago = PagoEntity(
            servicio: servicio,
            monto: monto,
            fecha: fecha
        )

        historialPagos.append(pago)
    }
}
