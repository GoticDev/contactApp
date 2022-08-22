//
//  Services.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import Foundation
import Combine

protocol ContactListServiceProtocol {
    var networkManager: NetworkManagerProtocol { get }
    func getContactList() -> AnyPublisher<[ContactListResponse], Error>
}


struct ContactListServices: ContactListServiceProtocol {
    
    static let shared: ContactListServices = {
        guard let manager = AppDelegate.sharedNetworkManager else {
            preconditionFailure("Missing Network Manager")
        }
        return ContactListServices(networkManager: manager)
    }()
    
    var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getContactList() -> AnyPublisher<[ContactListResponse], Error> {
        var request = HTTPRequest<EmptyData, [ContactListResponse]>(endpoint: Endpoint.contacts)
        return self.networkManager.request(request)
    }
    
    
}
