//
//  UserData.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/1.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import Foundation

struct UsersData {
    
    let name: String
    let email: String
    let image: String
    
    var toDict: [String: Any] {
        return [
            "name": name,
            "email": email,
            "image": image
            ]
    }
}

struct PetInfo {
    
    let ownerName: [String]
    let ownerImage: [String]
    let ownerEmail: [String]
    let petImage: [String]
    let petName: String
    let species: String
    let breed: String?
    let birth: String?
    let chip: String?
    let neuter: Bool
    let neuterDate: String?
    let memo: String?
    
    
}
