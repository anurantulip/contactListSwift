//
//  ContactDetails.swift
//  contactListSwift
//
//  Created by Anuran Ghosh on 17/05/18.
//  Copyright © 2018 Anuran Ghosh. All rights reserved.
//

import UIKit
class ContactDetails: UIViewController {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblUsername:UILabel!
    @IBOutlet weak var lblWebsite:UILabel!
    @IBOutlet weak var lblPhone:UILabel!
    @IBOutlet weak var lblAddressLine1:UILabel!
    @IBOutlet weak var lblAddressLine2:UILabel!
    @IBOutlet weak var lblCompanyName:UILabel!
    @IBOutlet weak var lblCompanyCatchPhrase:UILabel!
    @IBOutlet weak var lblCompanyBs:UILabel!
    
    var contactObj:Person?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.trash, target: self, action: #selector(btnDeleteAction))
        if let person = contactObj {
            self.title = person.name
            lblPhone.text = person.phone
            lblWebsite.text = person.website
            lblUsername.text = person.username
            lblCompanyName.text = person.company.name
            lblCompanyBs.text = person.company.bs
            lblCompanyCatchPhrase.text = person.company.catchPhrase
            lblAddressLine1.text = person.address.suite + ","+person.address.street
            lblAddressLine2.text = person.address.city + ","+person.address.zipcode
        }
    }
    
    @objc func btnDeleteAction(){
        let alertController = UIAlertController(title: "", message: "Are you sure to delete?", preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction) in
            if let id = self.contactObj?.id {
                NotificationCenter.default.post(name: .deleteContact, object: nil,userInfo:["id":id])
                self.backToMasterVc()
            }
        }
        
        let actionNo = UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func backToMasterVc(){
        if let splitController = self.splitViewController{
            if splitController.isCollapsed{
                let detailsNavCntrl = self.parent as! UINavigationController
                let masterNavcontroler = detailsNavCntrl.parent as! UINavigationController
                masterNavcontroler.popViewController(animated: true)
                
            }
        }
    }
}

