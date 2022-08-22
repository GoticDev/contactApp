//
//  Endpoint.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import Foundation

public protocol EndpointProtocol {
    
    var path: String { get }
    
}

public extension EndpointProtocol {
    
    func url(withBaseURL baseURL: String, queryItems: [URLQueryItem] = []) -> URL? {
        guard var components = URLComponents(string: baseURL+path) else { return nil }
        components.queryItems = queryItems
        return components.url
    }
    
}

public struct Endpoint: EndpointProtocol {
    
    public var path: String
    
    public init(path: String) {
        self.path = path
    }

}


extension Endpoint {
    
    static public var contacts: Endpoint {
        Endpoint(path: "users")
    }
    
    static public var publications: Endpoint {
        Endpoint(path: "posts")
    }

}
