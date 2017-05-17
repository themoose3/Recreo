//
//  LoginVC.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/13/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import SwiftKeychainWrapper

class LoginVC: UIViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var signInButton: TKTransitionSubmitButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        emailTextField.autocorrectionType = .no
        passwordTextField.delegate = self
        passwordTextField.autocorrectionType = .no
        
        signInButton.layer.cornerRadius = 25.0
        view.bringSubview(toFront: signInButton)
    }

    @IBAction func onTapFacebook(_ sender: UITapGestureRecognizer) {
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
                if let user  = user {
                    let userData = ["provider": credential.provider, "email": user.email, "userId": user.uid]
                    self.completeSignIn(id: user.uid, userData: userData as! Dictionary<String, String>)
                }
            }
        })
    }

    @IBAction func onTapSignIn(_ sender: Any) {
        signInButton.animate(duration: 1.5) { 
            if let email = self.emailTextField.text, let pwd = self.passwordTextField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    if error == nil {
                        print("AVINASH: Email/Password user authenticated with Firebase")
                        if let user  = user {
                            let userData = ["provider": user.providerID, "email": email, "userId": user.uid]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                            if error != nil {
                                print("AVINASH: Unable to create user with email/password")
                            } else {
                                print("AVINASH: Successfully created user with email/password")
                                if let user  = user {
                                    let userData = ["provider": user.providerID, "email": email, "userId": user.uid]
                                    self.completeSignIn(id: user.uid, userData: userData)
                                }
                            }
                        })
                    }
                })
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("AVINASH: User saved to keychain: \(keyChainResult)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogin"), object: nil)
        
        let defaults = UserDefaults.standard
        defaults.set(userData["userId"], forKey: "User")
        defaults.set(userData["email"], forKey: "UserEmail")
    }
}
