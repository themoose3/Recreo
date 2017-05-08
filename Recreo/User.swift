//
//  User.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation

class User {
    
    private var _userId: String!
    private var _email: String!
    private var _provider: String!
    
    private var _phoneNumber: String!
    private var _firstName: String!
    private var _lastName: String!
    private var _profileImage: URL!
    
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
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
    
    var profileImage: URL {
        return _profileImage
    }
    
    init(userId: String, email: String, firstName: String) {
        self._userId = userId
        self._email = email
        self._firstName = firstName
    }
    
    init(userId: String, userData: Dictionary<String, Any>) {
        self._userId = userId
        
        if let provider = userData["provider"] as? String {
            self._provider = provider
        }

        if let provider = userData["provider"] as? String {
            self._provider = provider
        }
    }
}
