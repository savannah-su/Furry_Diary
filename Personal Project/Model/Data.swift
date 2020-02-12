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

struct PetInfo: Codable {
    
    var ownersID: [String]
    var ownersName: [String]
    var ownersImage: [String]
    var petImage: [String]
    var petName: String
    var species: String
    var gender: String
    var breed: String?
    var color: String?
    var birth: String?
    var chip: String?
    var neuter: Bool
    var neuterDate: String?
    var memo: String?
    
    enum CodingKeys: String, CodingKey {
        
        case ownersID = "owners ID"
        case ownersName = "owners name"
        case ownersImage = "owners image"
        case petImage = "pet Images"
        case petName = "pet Name"
        case species = "pet species"
        case gender = "pet gender"
        case breed = "pet breed"
        case color = "pet color"
        case birth = "pet birth"
        case chip = "pet chip"
        case neuter = "neuter or not"
        case neuterDate = "neuter Date"
        case memo
    }
    
    var toDict: [String: Any] {
        return [
        "owners ID": ownersID,
        "owners name": ownersName,
        "owners image": ownersImage,
        "pet Images": petImage,
        "pet Name": petName,
        "pet species": species,
        "pet gender": gender,
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
