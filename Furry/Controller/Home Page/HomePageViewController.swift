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
import Crashlytics
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomePageViewController: UIViewController {

    @IBAction func logoutBotton(_ sender: Any) {
        logout()
    }
    
    @IBAction func createButton(_ sender: Any) {
       
        guard let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "Create Pet Page") as? CreatePetViewController else {
            return
        }
        present(viewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //製造Crash範例
        //Fabric.sharedSDK().debug = true
        
        getPetData()
        
        tableView.separatorColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPetData), name: Notification.Name("Create New Pet"), object: nil)

        addRefreshControl()
    }
    
    func logout() {
        
        //製造Crash範例
        //Crashlytics.sharedInstance().crash()
        
        let alertController = UIAlertController(title: "確定要登出嗎？", message: "", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "確定", style: .default) { _ in
            
            do {
               try Auth.auth().signOut()
                UserDefaults.standard.set(nil, forKey: "logInOrNot")

            } catch {
                print("登出失敗")
            }
                        
           let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "Login Page") as? LoginViewController
            self.view.window?.rootViewController = viewController
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func addRefreshControl() {
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(getPetData), for: .valueChanged)
        
    }
    
    @objc func getPetData() {
        
        UploadManager.shared.simplePetInfo.removeAll()
        DownloadManager.shared.petData.removeAll()
        
        DownloadManager.shared.downloadPetData { result in
            
            switch result {
                
            case .success(let downloadPetData):
                self.petData = downloadPetData
                self.alertView.isHidden = self.petData.count != 0
            case . failure(let error):
                print(error)
            }
        }
    }
}

extension HomePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let spring = UISpringTimingParameters(dampingRatio: 0.7, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: spring)
        
               cell.alpha = 0
        
               cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.6)
        
               animator.addAnimations {
                   cell.alpha = 1
                   cell.transform = .identity
                 self.tableView.layoutIfNeeded()
               }
        
               animator.startAnimation(afterDelay: 0.1 * Double(indexPath.item))
    }
    
}

extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Pet Card Cell", for: indexPath) as? PetCardCell else { return UITableViewCell() }
        
        cell.setCell(model: petData[indexPath.row])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toPetDetailPage(_:)))
        cell.background.addGestureRecognizer(tap)

        return cell
    }
    
    @objc func toPetDetailPage(_ sender: UIGestureRecognizer) {
        
        guard let viewController = UIStoryboard(name: "PetDetail", bundle: nil).instantiateViewController(identifier: "Pet Detail Page") as? PetDetailViewController else { return }

        guard let cell = sender.view?.superview?.superview as? PetCardCell,
              let indexPath = tableView.indexPath(for: cell)
            
        else {
            return
        }
        
        viewController.petData = petData[indexPath.row]
        
        show(viewController, sender: nil)
    }
    
}
