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
    let id: String
    
    var toDict: [String: Any] {
        return [
            "name": name,
            "email": email,
            "image": image,
            "id": id
        ]
    }
}

struct PetInfo {
    
    var ownersID: [String]
    var ownersName: [String]
    var ownersImage: [String]
    var petImage: [String]
    var petName: String
    var species: String
    var breed: String?
    var color: String?
    var birth: String?
    var chip: String?
    var neuter: Bool
    var neuterDate: String?
    var memo: String?
    
    var toDict: [String: Any] {
        return [
        "owners ID": ownersID,
        "owners name": ownersName,
        "owners image": ownersImage,
        "pet Images": petImage,
        "pet Name": petName,
        "pet species": species,
        "pet breed": breed as Any,
        "pet color": color as Any,
        "pet birth": birth as Any,
        "pet chip": chip as Any,
        "neuter or not": neuter,
        "neuter Date": neuterDate as Any,
        "memo": memo as Any
        ]
    }
}
