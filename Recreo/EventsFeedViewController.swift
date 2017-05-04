//
//  EventsFeedViewController.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EventsFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onSignOut(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("AVINASH: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "backToSignIn", sender: nil)
    }

}
