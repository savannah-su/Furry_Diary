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
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Local Noti
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, _) in
            if granted {
                print("User gave permissions for local notis.")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().delegate = self
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //fb login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //google login
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        IQKeyboardManager.shared.enable = true
        
        //Change Large Nav Bar Style
        //        let coloredAppearance = UINavigationBarAppearance()
        //        coloredAppearance.configureWithOpaqueBackground()
        //
        //        coloredAppearance.backgroundColor = .G2
        //        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        //
        //        let button = UIBarButtonItemAppearance()
        //        button.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        //        coloredAppearance.buttonAppearance = button
        //
        //
        //        UINavigationBar.appearance().standardAppearance = coloredAppearance
        //        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        if UserDefaults.standard.value(forKey: "logInOrNot") != nil {
            
            toNextpage()
            
        } else {
            
            let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "Login Page") as? LoginViewController
            
            window?.rootViewController = viewController
            
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
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
        
        Auth.auth().signIn(with: googleCredential) { (_, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("Google Login Sucessfully!")
            
            self.addToDatabase()
            
            self.toNextpage()
            
        }
    }
    
    @objc func toNextpage() {
        
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Tab Bar Controller") as? UITabBarController else {
            return
        }
        window?.rootViewController = viewController
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func addToDatabase() {
        
        guard let userID = Auth.auth().currentUser?.uid,
            let userEmail = Auth.auth().currentUser?.providerData.first?.email,
            let userName = Auth.auth().currentUser?.providerData.first?.displayName,
            let userPhoto = Auth.auth().currentUser?.providerData.first?.photoURL?.absoluteString else {
                return
        }
        
        var userPhotoString = ""
        
        guard let googlelPhoto = URL(string: userPhoto) else {
            return
        }
        
        let group = DispatchGroup()
        
        group.enter()
        getData(from: googlelPhoto) { (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            guard let photo = image.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            let storageRef = Storage.storage().reference().child("UserPhoto").child("\(userID).jpeg")
            
            storageRef.putData(photo, metadata: nil) { (_, error) in
                
                if error != nil {
                    print("To Storage Failed")
                    return
                }
                storageRef.downloadURL { (url, error) in
                    
                    if error != nil {
                        print("Get URL Failed")
                        return
                    }
                    
                    guard let backUserPhoto = url?.absoluteString else {
                        return
                    }
                    userPhotoString = backUserPhoto
                    group.leave()
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                
                let usersData = UsersData(name: userName, email: userEmail, image: userPhotoString, id: userID)
                
                Firestore.firestore().collection("users").document(userID).setData(usersData.toDict, completion: { (error) in
                    if error == nil {
                        
                        UserDefaults.standard.set(true, forKey: "logInOrNot")
                        UserDefaults.standard.set(userEmail, forKey: "email")
                        UserDefaults.standard.set(userName, forKey: "userName")
                        UserDefaults.standard.set(userPhotoString, forKey: "userPhoto")
                        UserDefaults.standard.set(userID, forKey: "userID")
                        
                        //self.toNextpage()
                        NotificationCenter.default.post(name: Notification.Name("toSearchOwnerPage"), object: nil)
                        
                        print("DB added successfully")
                        
                        self.toNextpage()
                        
                    } else {
                        print("Added failed")
                    }
                })
            }
            
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
