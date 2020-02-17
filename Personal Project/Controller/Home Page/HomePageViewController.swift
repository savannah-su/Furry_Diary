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
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    var refreshControl: UIRefreshControl!
    
    let manager = UploadManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name("Create New Pet"), object: nil)
        
        tableView.separatorColor = .clear
        
        getPetData()
        
        addRefreshControl()
    }
    
    func addRefreshControl() {
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
    }
    
    @objc func loadData() {
        
        getPetData()
    }
    
    func getPetData() {
        
        Firestore.firestore().collection("pets").getDocuments { (querySnapshot, error) in
            
            var petDataFromDB = [PetInfo]()
            
            if error == nil {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        
                        if let petInfo = try document.data(as: PetInfo.self, decoder: Firestore.Decoder()) {
                        
                            petDataFromDB.append(petInfo)
                            
                            let simplePet = simplePetInfo(petName: petInfo.petName, petID: petInfo.petID, petPhoto: petInfo.petImage)
                            
                            self.manager.simplePetInfo.append(simplePet)
                            
                        }
                        
                    } catch {
                        print(error)
                    }
                }
                self.petData = petDataFromDB
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
        cell.petImage = petData[indexPath.row].petImage
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetailPage(_:)))
        cell.background.addGestureRecognizer(tap)

        return cell
    }
    
    @objc func toDetailPage(_ sender: UIGestureRecognizer) {
        
        guard let vc = UIStoryboard(name: "PetDetail", bundle: nil).instantiateViewController(identifier: "Pet Detail Page") as? PetDetailViewController else { return }

        guard let cell = sender.view?.superview?.superview as? PetCardCell,
              let indexPath = tableView.indexPath(for: cell)
            
        else {
            return
        }
        
        vc.petData = petData[indexPath.row]
        
        show(vc, sender: nil)
    }
    
}
