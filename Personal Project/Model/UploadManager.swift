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

struct weight {
    
    let date: Int
    
    let kilo: Int
    
    var toDict: [String: Any] {
        
        return [
        
            "date": date,
            "kilo": kilo
        ]
    }
}

class UploadManager {
    
    static let shared = UploadManager()
    
    private init () {}
    
    let dbF = Firestore.firestore()
    
    func uploadWeight(petID: String, time: Int, kilo: Int, completion: @escaping (Result<String, Error>) -> Void) {
        
        let data = weight(date: time, kilo: kilo)
        
        
        dbF.collection("pets").document(petID).collection("weight").addDocument(data: data.toDict) { error in
            
            if error != nil {
                completion(.failure(upload.uploadFail))
            }
            
            completion(.success("Success"))
        }
    }
}
