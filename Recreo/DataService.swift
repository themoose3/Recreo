//
//  DataService.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/6/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("Users")
    private var _REF_EVENTS = DB_BASE.child("Events")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_EVENTS: FIRDatabaseReference {
        return _REF_EVENTS
    }
    
    var REF_CURRENT_USER: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let userRef = REF_USERS.child(uid!)
        return userRef
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
