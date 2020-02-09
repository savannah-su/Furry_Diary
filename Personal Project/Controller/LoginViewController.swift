//
//  LoginViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/1/30.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBAction func fbLogin(_ sender: Any) {
        fbLogin()
    }
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //google Login
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(Nextpage), name: Notification.Name("toSearchOwnerPage"), object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    func fbLogin() {
        
        let fbManager = LoginManager()
        fbManager.logIn(permissions: [.email], viewController: self) { [weak self] (result) in
            
            //fb log in
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                print("FB login ok")
                
                let fbCredential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                
                //create firebase auth
                Auth.auth().signIn(with: fbCredential) { [weak self] (result, error) in
                    guard let self = self else { return }
                    guard error == nil else {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    print("Firebase Auth ok")
                    
                    self.addToDatabase()
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                print("FB login failed")
            }
        }
    }
    
    func toNextpage() {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "searchOwnerPage") as? SearchOwnerViewController else { return }
        show(vc, sender: nil)
        
    }
    
    @objc func Nextpage() {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "searchOwnerPage") as? SearchOwnerViewController else { return }
        show(vc, sender: nil)
        
    }
    
    func addToDatabase() {
        
        guard let userID = Auth.auth().currentUser?.uid,
            let userEmail = Auth.auth().currentUser?.email,
            let userName = Auth.auth().currentUser?.displayName,
            let userPhoto = Auth.auth().currentUser?.photoURL?.absoluteString else { return }
        
        let usersData = UsersData(name: userName, email: userEmail, image: userPhoto, id: userID)
        
        Firestore.firestore().collection("users").document(userID).setData(usersData.toDict, completion: { (error) in
            
            if error == nil {
                
                UserDefaults.standard.set(true, forKey: "logInOrNot")
                UserDefaults.standard.set(userEmail, forKey: "email")
                UserDefaults.standard.set(userName, forKey: "userName")
                UserDefaults.standard.set(userPhoto, forKey: "userPhoto")
                UserDefaults.standard.set(userID, forKey: "userID")
                
                self.toNextpage()
                
                print("DB added successfully")
                
            } else {
                print("Added failed")
            }
        })
        
    }
    
}
