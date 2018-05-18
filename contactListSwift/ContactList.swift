//
//  ContactList.swift
//  contactListSwift
//
//  Created by Anuran Ghosh on 17/05/18.
//  Copyright © 2018 Anuran Ghosh. All rights reserved.
//

import UIKit
import Alamofire
class ContactList: UIViewController {
    @IBOutlet weak var tblview:UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredContacts = [Person]()
    var contactArray = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }
    }
    //MARK: - Sort Contact
    @IBAction func btnSortAction(btn:UIButton){
        if(btn.titleLabel?.text == "A-Z"){
            filteredContacts.sort{
                $0.name < $1.name
            }
            btn.setTitle("Z-A", for: .normal)
        }else{
            filteredContacts.sort{
                $0.name > $1.name
            }
            btn.setTitle("A-Z", for: .normal)
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
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person: Person
        person = filteredContacts[indexPath.row]
        let ContactDetails = Helper.storyBoard.instantiateViewController(withIdentifier: "ContactDetails") as! ContactDetails
            ContactDetails.contactObj = person
        self.navigationController?.pushViewController(ContactDetails, animated: true)
    }
}

extension Notification.Name{
    static let deleteContact = Notification.Name("deleteContact")
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

