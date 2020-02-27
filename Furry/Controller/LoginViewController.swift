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
import CryptoKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var appleLoginView: UIView!
    @IBOutlet weak var fbLoginBtn: UIButton!
    @IBAction func fbLoginBtn(_ sender: Any) {
        fbLogin()
    }
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    let appleLoginButton: ASAuthorizationAppleIDButton = {
        
        let button = ASAuthorizationAppleIDButton()
        
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupAppleBotton()
        
        //google Login
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    @objc func toNextpage() {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Tab Bar Controller") as? UITabBarController else {
            return
        }
        
        self.view.window?.rootViewController = vc
        
    }
    
    func setupAppleBotton() {
        
        appleLoginView.addSubview(appleLoginButton)
        
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleLoginButton.topAnchor.constraint(equalTo: appleLoginView.topAnchor),
            appleLoginButton.bottomAnchor.constraint(equalTo: appleLoginView.bottomAnchor),
            appleLoginButton.leadingAnchor.constraint(equalTo: appleLoginView.leadingAnchor),
            appleLoginButton.trailingAnchor.constraint(equalTo: appleLoginView.trailingAnchor)
        ])
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
                        print(error?.localizedDescription as Any)
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
    
    //Apple ID Sign In
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    fileprivate var currentNonce: String?
    
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self.addToDatabase()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

