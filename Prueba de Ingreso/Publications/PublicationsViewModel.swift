//
//  PublicationsViewModel.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import Foundation
import Combine
import ProgressHUD

class PublicationsViewModel {
    
    var publicationList = CurrentValueSubject<[PublicationsResponse], Error>([])
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
        ProgressHUD.show("Loading")
        self.publicationsSubscription = contactListService.getPublications(userId: userId)
            .sink(receiveCompletion: { (receiveCompletion) in
                switch receiveCompletion {
                case .finished:
                    print("finished")
                    ProgressHUD.dismiss()
                case .failure(let error):
                    print(error)
                    ProgressHUD.dismiss()
                }
            }, receiveValue: { [weak self] (response) in
                print(response)
                self?.list = response
                if let list = self?.list {
                    self?.publicationList.send(list)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    ProgressHUD.dismiss()
                    }
                }
                
            })
    }
    
    func cancel() {
        publicationsSubscription?.cancel()
    }
}
