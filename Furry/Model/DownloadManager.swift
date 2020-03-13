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

enum Download: Error {
    
    case downloadFail
}

class DownloadManager {
    
    static var shared = DownloadManager()
    
    private init() {}
    
    lazy var db = Firestore.firestore()
    
    var petData: [PetInfo] = []
    
    var petRecord = [Record]()
    
    var monthlyData = [Record]()
    
    var vetPlacemark = [VetDataToDB]()
    
    let category = ["衛生清潔", "預防計畫", "體重紀錄", "行為症狀", "醫療紀錄", "用藥紀錄"]
    
    func downloadPetData(completion: @escaping (Result<[PetInfo], Error>) -> Void) {
        
        db.collection("pets").whereField("owners ID", arrayContains: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, error) in
            
            if error == nil {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let downloadPetData = try document.data(as: PetInfo.self, decoder: Firestore.Decoder()) {
                            
                            self.petData.append(downloadPetData)
                            
                            let simplePet = SimplePetInfo(petName: downloadPetData.petName, petID: downloadPetData.petID, petPhoto: downloadPetData.petImage)
                            
                            UploadManager.shared.simplePetInfo.append(simplePet)
                        }
                        
                    } catch {
                        completion(.failure(Download.downloadFail))
                    }
                }
            }
            completion(.success(self.petData))
        }
    }
    
    func downloadRecordData(categoryType: Int, petID: String, completion: @escaping (Result<[Record], Error>) -> Void) {
        
        db.collection("pets").document(petID).collection("record").getDocuments { (querySnapshot, error) in
            
            if error == nil {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let downloadData = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                            self.petRecord.append(downloadData)
                        }
                        
                    } catch {
                        completion(.failure(Download.downloadFail))
                    }
                }
                
                if categoryType == 2 {
                    
                    let categoryData = self.petRecord.filter { info in
                        
                        if info.categoryType == self.category[categoryType] {
                            return true
                        } else {
                            return false
                        }
                    }
                    
                    completion(.success(categoryData))
                    
                } else {
                    completion(.success(self.petRecord))
                }
            }
        }
    }
    
    func downloadMonthlyRecordData(petID: String, startOfMonth: Date, endOfMonth: Date, completion: @escaping (Result<[Record], Error>) -> Void) {
        
        db.collection("pets").document(petID).collection("record").whereField("date", isGreaterThan: startOfMonth).whereField("date", isLessThan: endOfMonth).getDocuments { (querySnapshot, error) in
            
            if error == nil {
                
                self.monthlyData = []
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let downloadMonthlyData = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                            self.monthlyData.append(downloadMonthlyData)
                        }
                        
                    } catch {
                        completion(.failure(Download.downloadFail))
                    }
                }
                completion(.success(self.monthlyData))
            }
        }
    }
    
    func downloadVetPlacemark(completion: @escaping (Result<[VetDataToDB], Error>) -> Void) {
        
        vetPlacemark = []

        db.collection("veterinary").getDocuments { (querySnapshot, error) in
            
            if error == nil {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let downloadVetData = try document.data(as: VetDataToDB.self, decoder: Firestore.Decoder()) {
                            
                            self.vetPlacemark.append(downloadVetData)
                        }
                        
                    } catch {
                        completion(.failure(Download.downloadFail))
                    }
                    
                }
                completion(.success(self.vetPlacemark))
            }
        }
    }
}
