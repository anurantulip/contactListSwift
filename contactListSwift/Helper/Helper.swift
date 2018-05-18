//
//  Helper.swift
//  contactListSwift
//
//  Created by Anuran Ghosh on 17/05/18.
//  Copyright © 2018 Anuran Ghosh. All rights reserved.
//

import Foundation
import Alamofire

class Helper {
    lazy var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    static let sharedInstance = Helper()
    private init(){
          }
    static let baseUrl = "http://jsonplaceholder.typicode.com/users"
    static let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    static let appDel = UIApplication.shared.delegate
    static var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
     func showActivityIndicatory(uiView: UIView) {
        actInd.frame = CGRect(x: 0, y: 0, width: 50 , height: 50);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
    func hideActivityIndicatory(uiView: UIView) {
        actInd.stopAnimating()
    }
    func showAlert(vc: UIViewController, text:String) {
        let alertController = UIAlertController(title: "", message: text, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(actionYes)
        vc.present(alertController, animated: true, completion: nil)
    }
}
