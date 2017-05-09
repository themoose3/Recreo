//
//  Event.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//
import Foundation
import CoreLocation
import Firebase

class Event {
  
    //firebase references
    private var _eventRef: FIRDatabaseReference!
    private var _userRef: FIRDatabaseReference!
    
    // event metadata
    private var _eventId: String!
    private var _eventHost: User!
    private var _eventName: String!
    private var _eventDescription: String!
    
    var eventId: String {
        return _eventId
    }
    
    var eventHost: User {
        return _eventHost
    }

    var eventName: String {
        return _eventName
    }
    
    
    var eventDescription: String {
        return _eventDescription ?? ""
    }

    // event location
    private var _eventAddress: String!
    private var _eventCity: String!
    private var _eventState: String!
    private var _eventZip: Int16!
    private var _eventVenue: String!
    private var _eventVenueCoords: CLLocationCoordinate2D!
    
    var eventAddress: String {
        return _eventAddress
    }
    
    var eventCity: String {
        return _eventCity ?? ""
    }
    
    var eventState: String {
        return _eventState ?? ""
    }
    
    var eventZip:  Int16 {
        return _eventZip ?? 12345
    }
    
    var eventVenue: String {
        return _eventVenue ?? ""
    }
    
    var eventVenueCoords: CLLocationCoordinate2D {
        return _eventVenueCoords!
    }

    
    // event datetime
    private var _createdDate: Date!
    private var _eventDate: Date!
    private var _startDate: Date!
    private var _endDate: Date!
    
    var createdDate: Date {
        return _createdDate
    }
    
    var eventDate: Date {
        return _eventDate
    }
    
    var eventStartDate: Date {
        return _startDate ?? Date()
    }
    
    var eventEndDate: Date {
        return _endDate ?? Date()
    }

    
    // event invitees
    private var _invitees: [User]!
    
    var eventInvitees: [User] {
        return _invitees ?? []
    }
    
    // event assets
    private var _galleryId: String!
    private var _eventImageUrl: String?
    
    var eventGalleryId: String {
        return _galleryId ?? ""
    }
    
    var eventImageUrl: String {
        return _eventImageUrl ?? ""
    }
    
    init(eventName: String, host: User, createdDate: Date, eventDate: Date, address: String) {
        self._eventName = eventName
        self._eventHost = host
        self._createdDate = createdDate
        self._eventDate = eventDate
        self._eventAddress = address
    }
    
    init(eventId: String, eventData: Dictionary<String, Any>) {
        self._eventId = eventId
        self._eventRef = DataService.ds.REF_EVENTS.child(_eventId)

        if let eventName = eventData["eventName"] as? String {
            self._eventName = eventName
        }

        if let userKey = eventData["eventHost"] as? String {
            self._userRef = FIRDatabase.database().reference().child("users").child(userKey)
            self._userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print("USERY: \(snapshot.key)")
                if let userDict = snapshot.value! as? Dictionary<String, Any> {
                    let id = snapshot.key
                    self._eventHost = User(userId: id, userData: userDict)
                }
            })
        }

        if let createdDate = eventData["created"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

            self._createdDate = dateFormatter.date(from: createdDate)
        }

        if let eventDate = eventData["eventDate"] as? String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            self._eventDate = dateFormatter.date(from: eventDate)
        }
        
        if let eventImageUrl = eventData["imageUrl"] as? String {
            self._eventImageUrl = eventImageUrl
        }
        
        if let eventAddress = eventData["address"] as? String {
            self._eventAddress = eventAddress
        }
        
        if let eventVenue = eventData["venue"] as? String {
            self._eventVenue = eventVenue
        }
        
        if let eventCity = eventData["city"] as? String {
            self._eventCity = eventCity
        }

        if let eventState = eventData["state"] as? String {
            self._eventState = eventState
        }
        
        if let eventZip = eventData["zip"] as? Int16 {
            self._eventZip = eventZip
        }

    }
}
