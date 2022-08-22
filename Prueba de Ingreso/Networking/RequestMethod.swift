//
//  RequestMethod.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import Foundation

public protocol RequestMethod {
    var rawValue: String { get }
}

public enum HTTPMethod: String, RequestMethod {
    case get = "GET"
}
