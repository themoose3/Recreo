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
    private var _profileImageUrl: URL!
    
    private var _userRef: FIRDatabaseReference!
    
    private var _hostedEvents: [String: Bool]!
    private var _invitedEvents: [String: Bool]!
  
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
        return _firstName ?? "NoName"
    }
    
    var lastName: String {
        return _lastName ?? "User"
    }
    
    var profileImageUrl: URL {
        return _profileImageUrl ?? URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d3/User_Circle.png")!
    }
    
    var userRef: FIRDatabaseReference {
        return _userRef
    }
  
    var hostedEvents: [String:Bool]{
        return _hostedEvents
    }
  
    var invitedEvents: [String:Bool]{
        return _invitedEvents
    }
  
    init(userId: String, firstName: String) {
        print("AVINASH: User pass with init of userId and firstName")
        self._userId = userId
        self._firstName = firstName
    }
    
    init(userId: String, userData: Dictionary<String, Any>) {
        print("AVINASH: User pass with init of userDict")
        self._userId = userId
        self._userRef = DataService.ds.REF_USERS.child(userId)
        
        if let email = userData["email"] as? String {
            self._email = email
        }

        if let provider = userData["provider"] as? String {
            self._provider = provider
        }
        
        let profileImageUrlString = userData["profileImageUrl"] as? String
        if let profileImageUrlString = profileImageUrlString {
            self._profileImageUrl = URL(string: profileImageUrlString)
        }
        
        if let firstName = userData["firstName"] as? String {
            self._firstName = firstName
        }
        
        if let lastName = userData["lastName"] as? String {
            self._lastName = lastName
        }
    }
    
}
