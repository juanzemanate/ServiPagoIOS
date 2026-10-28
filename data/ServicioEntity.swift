//
//  ServicioEntity.swift
//  ServiPago
//
//  Created by MAC15 on 27/10/26.
//

import Foundation

struct ServicioEntity: Identifiable, Codable, Equatable {
    var id: Int64 = 0
    let nombre: String
    let tipo: String
    let monto: Int64
    let vencimientoMillis: Int64
    var pagado: Bool = false

    func tipoServicio() -> TipoServicio {
        return TipoServicio.allCases.first { $0.rawValue == tipo } ?? .OTRO
    }
}
