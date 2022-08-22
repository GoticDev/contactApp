//
//  HomeViewModel.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import Foundation
import Combine
import CoreData
import UIKit
import ProgressHUD

class HomeViewModel {
    
    var contactList = CurrentValueSubject<[ContactListResponse], Error>([])
    var contactsStorageList = CurrentValueSubject<[ContactsStorage], Never>([])
    var filterList = CurrentValueSubject<[ContactListResponse], Never>([])
    var filterStorageList = CurrentValueSubject<[ContactsStorage], Never>([])
    private var contactListService: ContactListServiceProtocol
    private var contactListSubscription: AnyCancellable?
    var list: [ContactListResponse]?
    
    var contacsStorage = [ContactsStorage]()
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(contactListService: ContactListServiceProtocol) {
        self.contactListService = contactListService
    }
    
    deinit {
        self.cancel()
    }
    
    func saveContacts(_ response: [ContactListResponse]) {
        for item in response {
            let newItem = ContactsStorage(context: self.contexto)
            newItem.id = Int32(item.id)
            newItem.name = item.name
            newItem.phone = item.phone
            newItem.email = item.email
            self.contacsStorage.append(newItem)
        }
        do {
            try contexto.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func getContactList() {
        do {
            let counter = try contexto.count(for: NSFetchRequest(entityName: "ContactsStorage"))
            if counter == 0 {
                if let currentSuscription = contactListSubscription {
                    currentSuscription.cancel()
                }
                ProgressHUD.show("Loading")
                self.contactListSubscription = contactListService.getContactList()
                    .sink(receiveCompletion: { (receiveCompletion) in
                        switch receiveCompletion {
                        case .finished:
                            print("finished")
                            ProgressHUD.dismiss()
                        case .failure(let error):
                            print(error)
                        }
                }, receiveValue: { (response) in
                    ProgressHUD.dismiss()
                    debugPrint(response)
                    self.list = response
                    self.saveContacts(response)
                    if let list = self.list {
                        self.contactList.send(list)
                    }
                })
            } else {
                //leer storage de contacts
                ProgressHUD.show("Loading")
                UserDefaults.standard.setValue(true, forKey: "storaged")
                let storage: NSFetchRequest<ContactsStorage> = ContactsStorage.fetchRequest()
                
                do {
                    ProgressHUD.dismiss()
                    contacsStorage = try contexto.fetch(storage)
                } catch {
                    print(error.localizedDescription)
                }
                self.contactsStorageList.send(self.contacsStorage)
            }
        } catch {
            ProgressHUD.dismiss()
            print(error.localizedDescription)
        }
    }
    
    func filter(text: String) {
        
        let isStoraged = UserDefaults.standard.bool(forKey: "storaged")
        if isStoraged {
            let newList = self.contactsStorageList.value.filter { (contact: ContactsStorage) in
                if contact.name!.lowercased().contains(text) {
                    return true
                } else {
                    return false
                }
            }
            
            if !text.isEmpty {
                self.filterStorageList.send(newList)
            } else {
                self.filterStorageList.send(self.contactsStorageList.value)
            }
        } else {
            let newList = self.contactList.value.filter { (contact: ContactListResponse) in
                if contact.name.lowercased().contains(text) {
                    return true
                } else {
                    return false
                }
            }
            if !text.isEmpty {
                self.filterList.send(newList)
            } else {
                self.filterList.send(self.contactList.value)
            }
        }
    }
    
    func cancel() {
        contactListSubscription?.cancel()
    }
}
