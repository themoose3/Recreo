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
    var invitees: [User]?
    var venue: String?
    var venueCoords: CLLocationCoordinate2D?
    var created: Date
    var eventDate: Date?
    var startTime: Date
    var endTime: Date?
    var galleryId: Gallery?
    var eventImage: URL?
    
    init(eventId: String, eventName: String, host: User, created: Date, startTime: Date) {
        self.eventId = eventId
        self.eventName = eventName
        self.host = host
        self.created = created
        self.startTime = startTime
    }
    
}
