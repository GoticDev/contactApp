//
//  ViewController.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var homeViewModel = HomeViewModel(contactListService: ContactListServices.shared)
    var cancellables: Set<AnyCancellable> = []
    var contactList: [ContactListResponse] = [ContactListResponse]()
    
    init() {
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tablita"
        registerTableView()
        homeViewModel.getContactList()
        bindingList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    func bindingList() {
        homeViewModel.contactList.sink { subs in
            switch subs {
                
            case .finished:
                print("finished")
            }
        } receiveValue: { response in
            self.contactList = response
            self.tableView.reloadData()
            print("refrescar tabla")
        }.store(in: &cancellables)

    }
    
    func registerTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "ContactListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ContactListTableViewCell")
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell", for: indexPath) as? ContactListTableViewCell else { return UITableViewCell() }
        cell.contactData(data: contactList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}
