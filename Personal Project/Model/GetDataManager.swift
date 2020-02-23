//
//  GetDataManager.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/22.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import Foundation


class GetDataManager {
    
    func getData(urlString: String, completion: @escaping (Result<[VetData], Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "Get"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                
                print(error!)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                print("Downcast HTTPURLResponse fail")
                return
            }
            
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300, let data = data else {
                
                print("Status Failed! \(httpResponse.statusCode)")
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let result = try decoder.decode([VetData].self, from: data)
                
                completion(.success(result))
                
//                print(result)
                
            } catch {
                
                print(error)
            }
        }.resume()
    }
    
    func getVetPlacemark(addressString: String, completion: @escaping (Result<[VetPlacemarkData], Error>) -> Void) {
            
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(addressString)&key=AIzaSyD9Sjc_momutj99pkja3PfeVAJbrqbuKAw"
        
        print(urlString)
        
            var request = URLRequest(url: URL(string: urlString)!)
            
            request.httpMethod = "Get"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard error == nil else {
                    
                    print(error!)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    
                    print("Downcast HTTPURLResponse fail")
                    return
                }
                
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300, let data = data else {
                    
                    print("Status Failed! \(httpResponse.statusCode)")
                    return
                }
                
                do {
                    
                    let decoder = JSONDecoder()
                    let result = try decoder.decode([VetPlacemarkData].self, from: data)
                    
                    completion(.success(result))
                    
                } catch {
                    
                    print(error)
                }
            }.resume()
        }
}
