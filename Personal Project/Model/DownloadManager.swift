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
    
    var petRecord = [Record]()
    
    var monthlyData = [Record]()
    
    let category = ["衛生清潔", "預防計畫", "體重紀錄", "行為症狀"]
    
    func downloadData(type: Int, petID: String, completion: @escaping (Result<[Record], Error>) -> Void) {
        db.collection("pets").document(petID).collection("record").getDocuments { (querySnapshot, error) in
            
            if error == nil {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let downloadData = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                            self.petRecord.append(downloadData)
                        }
                        
                    } catch {
                        completion(.failure(download.downloadFail))
                    }
                }
                
                if type == 4 {
                    
                    completion(.success(self.petRecord))
                    
                } else {
                    
                    let categoryData = self.petRecord.filter { info in
                        
                        if info.categoryType == self.category[type] {
                            return true
                        } else {
                            return false
                        }
                    }
                    completion(.success(categoryData))
                }
            }
        }
    }
    
    func downloadMonthlyData(petID: String, startOfMonth:Date, endOfMonth:Date, completion: @escaping (Result<[Record], Error>) -> Void) {
        db.collection("pets").document(petID).collection("record").whereField("date", isGreaterThan: startOfMonth).whereField("date", isLessThan: endOfMonth).getDocuments { (querySnapshot, error) in
            
            if error == nil {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let downloadMonthlyData = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                            self.monthlyData.append(downloadMonthlyData)
                        }
                        
                    } catch {
                        completion(.failure(download.downloadFail))
                    }
                    
                    completion(.success(self.monthlyData))
                }
            }
        }
    }
}
