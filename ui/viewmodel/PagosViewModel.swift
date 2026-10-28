//
//  PagosViewModel.swift
//  ServipagoIOS
//
//  Created by MAC16 on 28/10/26.
//
import Foundation
import Combine


/// ViewModel que guarda el estado de la pantalla de Pagos.
/// Expone el historial de pagos para actualizar la interfaz
/// automáticamente cuando se registra un pago.
final class PagosViewModel: ObservableObject {


    @Published var historialPagos: [PagoEntity] = []


    /// Registra un nuevo pago.
    /// Lo llama MisServicios al pulsar "Pagar".
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


       // historialPagos.append(pago)
    }
}
