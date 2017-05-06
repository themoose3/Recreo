//
//  User.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var userId: String
    var email: String
    var phoneNumber: String
    var firstName: String?
    var lastName: String?
    var profileImage: URL?
    
    init(userId: String, email: String, phoneNumber: String) {
        self.userId = userId
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
