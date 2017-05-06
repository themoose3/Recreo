//
//  LoginViewController.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onFacebookButtonTap(_ sender: Any) {
        let facebookLoginManager = LoginManager()
        
        facebookLoginManager.logIn([.email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print("AVINASH: \(error.localizedDescription)")
            case .cancelled:
                print("AVINASH: User canceled Facebook authentication")
            case .success(_, _, let accessToken):
                print("AVINASH: Succesfully authenticated with Facebook\n")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
            }
        }
    }
    
    @IBAction func onSigninTap(_ sender: Any) {
        if let email = emailTextField.text, let pwd = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("AVINASH: Email/Password user authenticated with Firebase")
                    if let user  = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("AVINASH: Unable to create user with email/password")
                        } else {
                            print("AVINASH: Successfully created user with email/password")
                            if let user  = user {
                                let userData = ["provider": user.providerID, "email": email]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
     func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("AVINASH: Unable to authenticate with Firebase: \(error!.localizedDescription)")
            } else {
                print("AVINASH: Successfully authenticated with Firebase\n")
                if let user  = user {
                    let userData = ["provider": credential.provider, "email": user.email]
                    self.completeSignIn(id: user.uid, userData: userData as! Dictionary<String, String>)
                }
            }
        })
    }
    
     func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("AVINASH: User saved to keychain: \(keyChainResult)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogin"), object: nil)
    }
}


