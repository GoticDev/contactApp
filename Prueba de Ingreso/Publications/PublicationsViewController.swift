//
//  PublicationsViewController.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import UIKit
import Combine
import CoreData

class PublicationsViewController: BaseViewController {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var publicationsViewModel = PublicationsViewModel(contactListService: ContactListServices.shared)
    var cancellables: Set<AnyCancellable> = []
    var contactList: ContactListResponse?
    var contactStorageList: ContactsStorage?
    var publicationList: [PublicationsResponse] = [PublicationsResponse]()
    var userId: Int = 1
    
    init() {
        super.init(nibName: "PublicationsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialSetup()
        setContactData()
        registerTableView()
        publicationsViewModel.getPublications(userId: String(self.userId))
        bindingPublicactionList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    private func setInitialSetup() {
        contactName.textColor = .principalColor
        contactName.font = .PI1
        contactPhone.font = .PI2
        contactEmail.font = .PI2
    }
    
    private func setContactData() {
        if let contactList = contactList {
            contactName.text = contactList.name
            contactPhone.text = contactList.phone
            contactEmail.text = contactList.email
        } else if let contactStorageList = contactStorageList {
            contactName.text = contactStorageList.name
            contactPhone.text = contactStorageList.phone
            contactEmail.text = contactStorageList.email
        } else {
            return }
        

    }
    
    private func registerTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "PublicationsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PublicationsTableViewCell")
    }
    
    private func bindingPublicactionList() {
        publicationsViewModel.publicationList
            .sink { subs in
                switch subs {
                    
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] (response) in
                self?.publicationList = response
                self?.tableView.reloadData()
            }.store(in: &cancellables)

    }
    
}

extension PublicationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PublicationsTableViewCell", for: indexPath) as? PublicationsTableViewCell else { return UITableViewCell() }
        cell.publicationData(data: publicationList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicationList.count
    }
}
