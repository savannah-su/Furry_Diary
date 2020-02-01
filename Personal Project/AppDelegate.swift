//
//  AppDelegate.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/1/21.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //fb login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //google login
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //fb login
        ApplicationDelegate.shared.application(app, open: url, options: options)
        
        //google login
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //googel login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let googleAuthentication = user.authentication else { return }
        
        let googleCredential = GoogleAuthProvider.credential(withIDToken: googleAuthentication.idToken, accessToken: googleAuthentication.accessToken)
        
        Auth.auth().signIn(with: googleCredential) { (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("Google Login Sucessfully!")
            
            //self.toNextpage()
            
            NotificationCenter.default.post(name: Notification.Name("toSearchOwnerPage"), object: nil)
            
            self.addToDatabase()
            
        }
        
    }
    
    //    func toNextpage() {
    //
    //        guard let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "searchOwnerPage") as? SearchOwnerViewController else { return }
    //       //vc.navigationController?.pushViewController(vc, animated: true)
    //        window?.rootViewController = vc
    //
    //    }
    
    func addToDatabase() {
        
        guard let id = Auth.auth().currentUser?.uid,
            let userEmail = Auth.auth().currentUser?.email,
            let userName = Auth.auth().currentUser?.displayName,
            let userPhoto = Auth.auth().currentUser?.photoURL?.absoluteString else { return }
        
        let usersData = UsersData(name: userName, email: userEmail, image: userPhoto)
        
        Firestore.firestore().collection("users").document(id).setData(usersData.toDict, completion: { (error) in
            if error == nil {
                
                UserDefaults.standard.set(true, forKey: "logInOrNot")
                UserDefaults.standard.set(userEmail, forKey: "email")
                UserDefaults.standard.set(userName, forKey: "userName")
                UserDefaults.standard.set(userPhoto, forKey: "userPhoto")
                
                print("DB added successfully")
            } else {
                print("Added failed")
            }
        })
        
    }
    
}

