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

struct simplePetInfo {

    let petName: String

    let petID: String

    let petPhoto: [String]

}

class UploadManager {
    
    static var shared = UploadManager()
    
    private init() {}
    
    lazy var db = Firestore.firestore()
    
    var simplePetInfo: [simplePetInfo] = []
    
    func uploadData(petID: String, categoryType: String, date: String, subitem: [String], medicineName: String, kilo: String, memo: String, notiOrNot: String, notiDate: String, notiText: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let data = Record(categoryType: categoryType, subitem: subitem, medicineName: medicineName, kilo: kilo, memo: memo, date: date, notiOrNot: notiOrNot, notiDate: notiDate, notiText: notiText)
        
        db.collection("pets").document(petID).collection("record").addDocument(data: data.toDict) { error in
            
            if error != nil {
                
                completion(.failure(upload.uploadFail))
            }
            
            completion(.success("Success"))
        }
    }
}
