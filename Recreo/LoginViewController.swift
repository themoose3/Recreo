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
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("AVINASH: Unable to authenticate with Firebase: \(error!.localizedDescription)")
            } else {
                print("AVINASH: Successfully authenticated with Firebase\n")
            }
        })
    }

    @IBAction func onSigninTap(_ sender: Any) {
        if let email = emailTextField.text, let pwd = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("AVINASH: Email/Password user authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("AVINASH: Unable to create user with email/password")
                        } else {
                            print("AVINASH: Successfully created user with email/password")
                        }
                    })
                }
            })
        }
    }
}
