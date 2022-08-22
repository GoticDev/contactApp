//
//  ViewController.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import UIKit
import Combine

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    var homeViewModel = HomeViewModel(contactListService: ContactListServices.shared)
    var cancellables: Set<AnyCancellable> = []
    var contactList: [ContactListResponse] = [ContactListResponse]()
    var searchController : UISearchController?
    
    init() {
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Prueba de ingreso"
        initialSetup()
        registerTableView()
        homeViewModel.getContactList()
        bindingList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        self.searchController?.searchBar.text = ""
        creatingSearhBar()
    }

    private func initialSetup() {
        
        emptyListLabel.isHidden = true
    }
    
    private func bindingList() {
        if homeViewModel.contacsStorage.count > 0 {
            homeViewModel.contactsStorageList.sink { subs in
                switch subs {
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] (response) in
                guard let self = self else { return }
                self.tableView.reloadData()
            }.store(in: &cancellables)
            
        } else {
            homeViewModel.contactList.sink { subs in
                switch subs {
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] (response) in
                guard let self = self else { return }
                self.contactList = response
                self.tableView.reloadData()
            }.store(in: &cancellables)
        }
    }
    
    private func registerTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "ContactListTableViewCell",
                        bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ContactListTableViewCell")
    }
    
    func creatingSearhBar() {
       self.searchController = UISearchController(searchResultsController: nil)
       self.tableView.tableHeaderView = self.searchController?.searchBar
       self.searchController?.searchResultsUpdater = self
       self.searchController?.searchBar.showsBookmarkButton = true
       self.searchController?.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle"),
                                                  for: UISearchBar.Icon.bookmark,
                                                  state: .normal)
        self.searchController?.searchBar.delegate = self
        
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell", for: indexPath) as? ContactListTableViewCell else { return UITableViewCell() }
        let isStoraged = UserDefaults.standard.bool(forKey: "storaged")
        
        if isStoraged {
            if (self.searchController?.searchBar.isFirstResponder ?? false) {
                cell.contactStorageData(data: homeViewModel.filterStorageList.value[indexPath.row])
            } else {
                cell.contactStorageData(data: homeViewModel.contactsStorageList.value[indexPath.row])
            }
            
        } else {
            if (self.searchController?.searchBar.isFirstResponder ?? false) {
                cell.contactData(data: homeViewModel.filterList.value[indexPath.row])
            } else {
                cell.contactData(data: homeViewModel.contactList.value[indexPath.row])
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isStoraged = UserDefaults.standard.bool(forKey: "storaged")
        
        if isStoraged {
            if (self.searchController?.searchBar.isFirstResponder ?? false) {
                return homeViewModel.filterStorageList.value.count
            } else {
                return homeViewModel.contactsStorageList.value.count
            }
        } else {
            if (self.searchController?.searchBar.isFirstResponder ?? false) {
                return homeViewModel.filterList.value.count
            } else {
                return homeViewModel.contactList.value.count
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PublicationsViewController()
        let isStoraged = UserDefaults.standard.bool(forKey: "storaged")
        
        if isStoraged {
            if (self.searchController?.searchBar.isFirstResponder ?? false) {
                vc.userId = Int(homeViewModel.filterStorageList.value[indexPath.row].id)
                vc.contactStorageList = homeViewModel.filterStorageList.value[indexPath.row]
            } else {
                vc.userId = Int(homeViewModel.contactsStorageList.value[indexPath.row].id)
                vc.contactStorageList = homeViewModel.contactsStorageList.value[indexPath.row]
            }
        } else {
            if (self.searchController?.searchBar.isFirstResponder ?? false) {
                vc.userId = homeViewModel.filterList.value[indexPath.row].id
                vc.contactList = homeViewModel.filterList.value[indexPath.row]
            } else {
                vc.userId = homeViewModel.contactList.value[indexPath.row].id
                vc.contactList = homeViewModel.contactList.value[indexPath.row]
            }
            
        }
        
        self.searchController?.searchBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.homeViewModel.filter(text: self.searchController?.searchBar.text!.lowercased() ?? "")
        let isStoraged = UserDefaults.standard.bool(forKey: "storaged")
        if isStoraged {
            if self.homeViewModel.filterStorageList.value.count == 0 {
                self.emptyListLabel.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.emptyListLabel.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        } else {
            if self.homeViewModel.filterList.value.count == 0 {
                self.emptyListLabel.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.emptyListLabel.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
        
    }
}
