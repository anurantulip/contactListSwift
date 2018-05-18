//
//  person.swift
//  contactListSwift
//
//  Created by Anuran Ghosh on 17/05/18.
//  Copyright © 2018 Anuran Ghosh. All rights reserved.
//

import UIKit

struct Person: Decodable{
    let id:Int
    let name:String
    let username:String
    let email:String
    let company:Company
    let address:Address
    let phone:String
    let website:String
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case company = "company"
        case address = "address"
        case phone = "phone"
        case website = "website"
    }
}

struct Company: Decodable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    
    enum CodingKeys : String, CodingKey {
        case street = "street"
        case suite = "suite"
        case city = "city"
        case zipcode = "zipcode"
    }
}

