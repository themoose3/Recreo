//
//  User.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    private var _userId: String!
    private var _email: String!
    private var _provider: String!
    
    private var _phoneNumber: String!
    private var _firstName: String!
    private var _lastName: String!
<<<<<<< HEAD
    private var _profileImage: URL!
  
    private var _hostedEvents: [String: Bool]!
    private var _invitedEvents: [String: Bool]!
  
=======
    private var _profileImageUrl: String!
    
    private var _userRef: FIRDatabaseReference!
    
>>>>>>> master
    var userId: String {
        return _userId
    }
    
    var email: String {
        return _email
    }

    var provider: String {
        return _provider
    }
    
    var phoneNumber: String {
        return _phoneNumber
    }
    
    var firstName: String {
        return _firstName ?? "Dino"
    }
    
    var lastName: String {
        return _lastName ?? "Juliet"
    }
    
    var profileImageUrl: String {
        return _profileImageUrl ?? ""
    }
    
    var userRef: FIRDatabaseReference {
        return _userRef
    }
<<<<<<< HEAD
  
    var hostedEvents: [String:Bool]{
        return _hostedEvents
    }
  
    var invitedEvents: [String:Bool]{
        return _invitedEvents
    }
  
    init(userId: String, email: String, firstName: String) {
=======
    
    init(userId: String) {
>>>>>>> master
        self._userId = userId
    }
    
    init(userId: String, userData: Dictionary<String, Any>) {
        self._userId = userId
        self._userRef = DataService.ds.REF_USERS.child(userId)
        
        if let email = userData["email"] as? String {
            self._email = email
        }

        if let provider = userData["provider"] as? String {
            self._provider = provider
        }
        
        if let profileImageUrl = userData["profileImageUrl"] as? String {
            self._profileImageUrl = profileImageUrl
        }
        
        if let firstName = userData["firstName"] as? String {
            self._firstName = firstName
        }
        
        if let lastName = userData["lastName"] as? String {
            self._lastName = lastName
        }
        
    }
}
