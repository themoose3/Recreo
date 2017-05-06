//
//  Event.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation
import CoreLocation

class Event: NSObject {
    
    var eventId: String
    var eventName: String
    var eventDescription: String?
    var host: User
    var invitees = [String: String?]()
    var venue: String?
    var address: String
    var created: String
    var startDate: String
    var endDate: String
    var galleryId: Gallery?
    var eventImage: URL?
    
    init(eventId: String, eventName: String, host: User, created: String, startDate: String, endDate: String, address: String) {
        self.eventId = eventId
        self.eventName = eventName
        self.host = host
        self.created = created
        self.startDate = startDate
        self.endDate = endDate
        self.address = address
    }
    
}
