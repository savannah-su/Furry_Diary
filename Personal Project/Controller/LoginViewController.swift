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

        // Do any additional setup after loading the view.
    }
    
    func fbLogin() {
        
        let fbManager = LoginManager()
        fbManager.logIn(permissions: [.email], viewController: self) { [weak self] (result) in
            
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                print("login ok")
                
                let fbCredential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: fbCredential) { [weak self] (result, error) in
                    guard let self = self else { return }
                        guard error == nil else {
                            print(error?.localizedDescription)
                            return
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                
            } else {
                print("login fail")
            }
        }
    }
    
}
