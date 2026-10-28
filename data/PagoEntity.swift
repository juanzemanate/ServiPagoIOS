//
//  PagoEntity.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import Foundation

/// Registro de un pago realizado en la base de datos local.
struct PagoEntity: Identifiable, Codable, Equatable {
    var id: Int64 = 0
    let servicio: String
    let monto: String
    let fecha: String
    var estado: String = "Pagado"
}
