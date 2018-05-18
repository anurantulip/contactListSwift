//
//  ContactList.swift
//  contactListSwift
//
//  Created by Anuran Ghosh on 17/05/18.
//  Copyright © 2018 Anuran Ghosh. All rights reserved.
//

import UIKit
import Alamofire
enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone
    case pad
}
class ContactList: UIViewController {
    @IBOutlet weak var tblview:UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredContacts = [Person]()
    var contactArray = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Z-A", style: .plain, target: self, action: #selector(btnSortAction))
            self.title = "Contact List"
           // Setup the Search Controller
        
           searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tblview.tableHeaderView = searchController.searchBar
        
        tblview.tableFooterView = UIView()
        //tblview.tableHeaderView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(deleteContact(notification:)), name: .deleteContact, object: nil)
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchController.dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Delete Contact
    @objc func deleteContact(notification:Notification){
        if let id = notification.userInfo?["id"] as? Int {
            contactArray = contactArray.filter{
                $0.id != id
            }
            filteredContacts = filteredContacts.filter{
                $0.id != id
            }
            self.tblview.reloadData()
            // Refresh details view
            if UIDevice.current.userInterfaceIdiom == .pad{
                self.refreshDetailView()
            }
        }
    }
    //MARK: - Sort Contact
    @objc func btnSortAction(){
    if(navigationItem.rightBarButtonItem?.title == "A-Z"){
            filteredContacts.sort{
                $0.name < $1.name
            }
            navigationItem.rightBarButtonItem?.title = "Z-A"
        }else{
            filteredContacts.sort{
                $0.name > $1.name
            }
            navigationItem.rightBarButtonItem?.title = "A-Z"
        }
        self.tblview.reloadData()
        
    }
    
    //MARK: - Load Contact From URL
    func loadData() {
        guard Helper.isConnectedToInternet else{
            print ("no connection")
            Helper.sharedInstance.showAlert(vc: self, text:"No network connection available.")
            return
        }
        Helper.sharedInstance.showActivityIndicatory(uiView: self.view)
        NetworkManager.sharedInstance.loadContact(){
            self.contactArray = $0
            self.contactArray.sort{
                $0.name < $1.name
            }
            self.filteredContacts = self.contactArray
            Helper.sharedInstance.hideActivityIndicatory(uiView: self.view)
            self.tblview.reloadData()
            // Refresh details view
            if UIDevice.current.userInterfaceIdiom == .pad{
                self.refreshDetailView()
            }
            
        }
    }
    func refreshDetailView(){
        let indexPath = IndexPath(row: 0, section: 0)
        self.tblview.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        self.performSegue(withIdentifier: "ShowDetailIdentifier" , sender:self)
    }
    // MARK:- Storyboard segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowDetailIdentifier") {
            let detail: ContactDetails
            if let navigationController = segue.destination as? UINavigationController {
                detail = navigationController.topViewController as! ContactDetails
            } else {
                detail = segue.destination as! ContactDetails
            }
            
            if let path = tblview.indexPathForSelectedRow {
                let person: Person = filteredContacts[path.row]
                detail.contactObj = person
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
    
}
// MARK: - UITableViewDataSource
extension ContactList:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:contactCell = self.tblview.dequeueReusableCell(withIdentifier: "contactCell") as! contactCell
        let person:Person = filteredContacts[indexPath.row]
        cell.lblName.text = person.name
        cell.lblEmail.text = person.email
        cell.selectionStyle = .none
        return cell
    }
    
    
}
// MARK: - UITableViewDelegate
extension ContactList:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension Notification.Name{
    static let deleteContact = Notification.Name("deleteContact")
    static let loadInitialValue = Notification.Name("loadInitialValue")
}
// MARK: - UISearchResultsUpdating Delegate
extension ContactList: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredContacts = contactArray.filter({( person : Person) -> Bool in
                return person.name.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredContacts = contactArray
        }
        tblview.reloadData()
    }

}

