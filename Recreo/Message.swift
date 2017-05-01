//
//  Message.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation


class Message: NSObject {
    
    var messageId: Int
    var text: String
    var userId: Int
    var timestamp: Date
    var conversationId: Int
    
    init(messageId: Int, text: String, userId: Int, timestamp: Date, conversationId: Int) {
        self.messageId = messageId
        self.text = text
        self.userId = userId
        self.timestamp = timestamp
        self.conversationId = conversationId
    }
}
