//
//  UploadManager.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/14.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

enum upload: Error {
    
    case uploadFail
}

struct Record {
    
    let categoryType: String
    let subItem: String?
    let title: String?
    let kilo: String?
    let memo: String?
    let date: String
    let notiOrNot: String?
    let notiDate: String?
    let notiText: String?
    
    var toDict: [String: Any] {
        
        return [
            
            "category tpye": categoryType,
            "subitem ": subItem as Any,
            "medical title": title as Any,
            "kilo": kilo as Any,
            "memo": memo as Any,
            "date": date,
            "noti or not": notiOrNot as Any,
            "noti Date": notiDate as Any,
            "noti text": notiText as Any
        ]
    }
}

struct simplePetInfo {

    let petName: String

    let petID: String

    let petPhoto: [String]

}

class UploadManager {
    
    lazy var db = Firestore.firestore()
    
    var simplePetInfo: [simplePetInfo] = []
    
    func uploadData(petID: String, categoryType: String, date: String, subItem: String, title: String, kilo: String, memo: String, notiOrNot: String, notiDate: String, notiText: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let data = Record(categoryType: categoryType, subItem: subItem, title: title, kilo: kilo, memo: memo, date: date, notiOrNot: notiOrNot, notiDate: notiDate, notiText: notiText)
        
        db.collection("pets").document(petID).collection("record").addDocument(data: data.toDict) { error in
            
            if error != nil {
                completion(.failure(upload.uploadFail))
            }
            
            completion(.success("Success"))
        }
    }
}
