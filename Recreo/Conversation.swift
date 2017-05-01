//
//  Conversation.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation


class Conversation: NSObject {
    
    var conversationId: Int
    var messages: [Message]?
    var eventId: Int

    init(conversationId: Int, eventId: Int) {
        self.conversationId = conversationId
        self.eventId = eventId
    }
}
