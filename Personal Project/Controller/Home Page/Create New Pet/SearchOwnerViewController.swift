//
//  SearchOwnerViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/1/31.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SearchOwnerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func okButton(_ sender: Any) {
        
        let selectedOwners: [UsersData] = ownerData.compactMap({ owner in
            
            if owner.isSelected {
                return owner
            } else {
                return nil
            }
        })
        
        print(selectedOwners)
//        selectHandler?([ownerData[indexRow]])
//
//        dismiss(animated: true, completion: nil)
//
//        toNextpage()
    }
    
    var indexRow = 0
    
    var searchEmpty: Bool = true
    
    var ownerData = [UsersData]() {
        
        didSet {
            if ownerData.isEmpty {
                return
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var selectHandler: (([UsersData]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        guard let currentUser = UserDefaults.standard.value(forKey: "userName") else { return }
        currentUserLabel.text = "Hello, \(currentUser)!"
        
        getOwnerData()
        // Do any additional setup after loading the view.
    }
    
    func getOwnerData() {
        
        Firestore.firestore().collection("users").getDocuments { (querySnapshot, error) in
            
            if error == nil {
                for document in querySnapshot!.documents {
                    
                    guard let userName = UserDefaults.standard.value(forKey: "userName") as? String else { return }
                    
                    guard let name = document.data()["name"] as? String,
                        let image = document.data()["image"] as? String,
                        let email = document.data()["email"] as? String,
                        let id = document.data()["id"] as? String else { return }
                    
                    if name == userName {
                        
                        //break, return, continue
                        continue
                        
                    } else {
                        
                        let usersData = UsersData(name: name, email: email, image: image, id: id)
                        
                        self.ownerData.append(usersData)
                        
                    }
                }
            }
        }
    }
    
    func toNextpage() {

        navigationController?.popViewController(animated: true)
    }
}

extension SearchOwnerViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ownerData[indexPath.row].isSelected = !ownerData[indexPath.row].isSelected
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.backgroundColor = ownerData[indexPath.row].isSelected ? .yellow : .white
    }
}

extension SearchOwnerViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ownerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Owner Cell", for: indexPath) as? OwnerTableViewCell else {
            return UITableViewCell()
        }
        
        let url = URL(string: ownerData[indexPath.row].image)
        let data = try! Data(contentsOf: url!)
        cell.ownerImage.image = UIImage(data: data)
        cell.ownerName.text = ownerData[indexPath.row].name
        
        cell.backgroundColor = ownerData[indexPath.row].isSelected ? .yellow : .white
        
        return cell
    }
}

extension SearchOwnerViewController: UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        ownerData = ownerData.filter { user in
            
            return true
        }
    }
}
