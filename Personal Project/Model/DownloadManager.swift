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
    
    func downloadData(petID: String, completion: @escaping (Result<[Record], Error>) -> Void) {
        db.collection("pets").document(petID).collection("record").getDocuments { (querySnapshot, error) in
            
            var petRecord = [Record]()
            
            if error == nil {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let downloadData = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                            petRecord.append(downloadData)
                        }
                        
                        
                    } catch {
                        completion(.failure(upload.uploadFail))
                    }
                }
                completion(.success(petRecord))
            }
        }
    }
}
