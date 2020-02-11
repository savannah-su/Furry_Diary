//
//  HomePageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/5.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomePageViewController: UIViewController {

    @IBAction func createButton(_ sender: Any) {
       
        guard let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "Create Pet Page") as? CreatePetViewController else { return }
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var petData = [PetInfo]() {
        
        didSet {
            if petData.isEmpty {
                return
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorColor = .clear
        
        getPetData()
    }
    
    func getPetData() {
        
        Firestore.firestore().collection("pets").getDocuments { (querySnapshot, error) in
            
            if error == nil {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let petInfo = try document.data(as: PetInfo.self, decoder: Firestore.Decoder()) {
                        
                        self.petData.append(petInfo)
                            
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

extension HomePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
    }
    
}

extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Pet Card Cell", for: indexPath) as? PetCardCell else { return UITableViewCell() }
        
        cell.petName.text = petData[indexPath.row].petName
        cell.genderAndOld.text = petData[indexPath.row].gender
        cell.tag = indexPath.row
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetailPage(_:)))
        cell.background.addGestureRecognizer(tap)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func toDetailPage(_ sender: UIGestureRecognizer) {
        
        guard let vc = UIStoryboard(name: "PetDetail", bundle: nil).instantiateViewController(identifier: "Pet Detail Page") as? PetDetailViewController else { return }
        
//        vc.petData = petData
        guard let cell = sender.view?.superview?.superview as? PetCardCell,
              let indexPath = tableView.indexPath(for: cell)
        else {
            
            return
        }
        
//        let data = petData[indexPath.row]
        
        vc.petData = petData[indexPath.row]
        
        show(vc, sender: nil)
    }
    
}
