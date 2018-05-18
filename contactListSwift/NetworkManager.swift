//
//  NetworkManager.swift
//  contactListSwift
//
//  Created by Anuran Ghosh on 17/05/18.
//  Copyright © 2018 Anuran Ghosh. All rights reserved.
//

import Foundation
import Alamofire
class NetworkManager{
    static let sharedInstance = NetworkManager()
    private init(){}
    func loadContact(callback:@escaping ([Person])->()){
        Alamofire.request(Helper.baseUrl)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                guard let data = response.data else {
                    print("Error: No data to decode")
                    return
                }
                guard let contactArray = try? JSONDecoder().decode([Person].self, from: data) else {
                    print("Error: Couldn't decode data into Blog")
                    return
                }
                callback(contactArray)
        }
    }
}
