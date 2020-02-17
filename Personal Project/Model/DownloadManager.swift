//
//  DownloadManager.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/17.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

enum download: Error {
    
    case downloadFail
}

class DownloadManager {
    
    static var shared = DownloadManager()
    
    private init() {}
    
    lazy var db = Firestore.firestore()
    
    func downloadData() {
        
        Firestore.firestore().collection("pets").document(petID).collection("record").whereField("category type", isEqualTo: "體重紀錄").getDocuments { error in
        if error != nil {
            completion(.failure(download.downloadFail))
            } else {
                completion(.success("Success"))
            }
        }
    }
}
