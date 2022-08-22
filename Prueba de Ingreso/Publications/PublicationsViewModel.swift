//
//  PublicationsViewModel.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import Foundation
import Combine

class PublicationsViewModel {
    
    var publicationList = CurrentValueSubject<[PublicationsResponse], Never>([])
    private var contactListService: ContactListServiceProtocol
    private var publicationsSubscription: AnyCancellable?
    var list: [PublicationsResponse]?
    
    init(contactListService: ContactListServiceProtocol) {
        self.contactListService = contactListService
    }
    
    deinit {
        self.cancel()
    }
    
    func getPublications(userId: String) {
        if let currentSuscription = publicationsSubscription {
            currentSuscription.cancel()
        }
        self.publicationsSubscription = contactListService.getPublications(userId: userId)
            .sink(receiveCompletion: { (receiveCompletion) in
                switch receiveCompletion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] (response) in
                print(response)
                self?.list = response
                if let list = self?.list {
                    self?.publicationList.send(list)
                }
            })
    }
    
    func cancel() {
        publicationsSubscription?.cancel()
    }
}