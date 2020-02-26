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
    var isSelected: Bool = false
    
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
    
    var petID: String
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
        
        case petID = "pet ID"
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
            "pet ID": petID,
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

//enum RecordType: Int, Codable {
//    case weight = 0
//    case clean
//}


struct Record: Codable {
    
    static var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    let categoryType: String
    let subitem: [String]?
    let medicineName: String?
    let kilo: String?
    let memo: String?
    let date: Date
    let notiOrNot: String?
    let notiDate: String?
    let notiText: String?
    
    lazy var dateString: String = Record.dateFormatter.string(from: date)
    
    var content: String {
        switch categoryType {
        case "衛生清潔": return "下次清潔是\(notiDate ?? "")"
        case "預防計畫": return ""
        case "體重紀錄": return ""
        case "行為症狀": return ""
        default:return ""
        }
    }
    
    var subContent: String {
        switch categoryType {
        case "衛生清潔": return "下次清潔是\(notiDate ?? "")"
        case "衛生清潔": return ""
        default:return ""
        }
    }
    
    //    var height: CGFloat {
    //        switch categoryType {
    //        case "衛生清潔": return "下次清潔是\(notiDate ?? "")"
    //        case "衛生清潔": return ""
    //        default:return ""
    //        }
    //    }
    
    enum CodingKeys: String, CodingKey {
        
        case categoryType = "category tpye"
        case medicineName = "medicine name"
        case notiOrNot = "noti or not"
        case notiDate = "noti Date"
        case notiText = "noti text"
        case subitem, kilo, memo, date
        
    }
    
    var toDict: [String: Any] {
        
        return [
            
            "category tpye": categoryType,
            "subitem": subitem as Any,
            "medicine name": medicineName as Any,
            "kilo": kilo as Any,
            "memo": memo as Any,
            "date": date,
            "noti or not": notiOrNot as Any,
            "noti Date": notiDate as Any,
            "noti text": notiText as Any
        ]
    }
}

struct WeightData {
    
    let date: Date
    let weight: Double
}

struct VetData: Codable {
    
    let vetName: String
    let vetPhone: String
    let vetAddress: String
    
    
    enum CodingKeys: String, CodingKey {
        
        case vetName = "機構名稱"
        case vetPhone = "機構電話"
        case vetAddress = "機構地址"
    }
}

struct VetDataToDB: Codable {
    
    let vetName: String
    let vetPhone: String
    let vetAddress: String
    let vetLatitude: Double
    let vetLongitude: Double
    
    var toDict: [String: Any] {
        
        return [
            
            "vetName": vetName,
            "vetPhone": vetPhone,
            "vetAddress": vetAddress,
            "vetLatitude": vetLatitude,
            "vetLongitude": vetLongitude
        ]
    }
}

struct VetPlacemarkData: Codable {
    let results: [ResultData]
}

struct ResultData: Codable {
    let geometry: Geometry
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat, lng: Double
}
