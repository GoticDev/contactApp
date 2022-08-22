//
//  +Bundle.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import Foundation

extension Bundle {
    
    static var baseURL: String? {
        return Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String
    }
    
}
