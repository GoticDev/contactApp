//
//  HomeViewModel.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import Foundation
import Combine

class HomeViewModel {
    
    var contactList = CurrentValueSubject<[ContactListResponse], Never>([])
    private var contactListService: ContactListServiceProtocol
    private var contactListSubscription: AnyCancellable?
    var list: [ContactListResponse]?
    
    init(contactListService: ContactListServiceProtocol) {
        self.contactListService = contactListService
    }
    
    deinit {
        self.cancel()
    }
    
    func getContactList() {
        if let currentSuscription = contactListSubscription {
            currentSuscription.cancel()
        }
        self.contactListSubscription = contactListService.getContactList()
            .sink(receiveCompletion: { (receiveCompletion) in
                switch receiveCompletion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
        }, receiveValue: { (response) in
            print("lita de contactos ok")
            debugPrint(response)
            self.list = response
            if let list = self.list {
                self.contactList.send(list)
            }
        })
    }
    
    func cancel() {
        contactListSubscription?.cancel()
    }
}
