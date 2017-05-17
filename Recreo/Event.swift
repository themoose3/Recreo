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
        return _eventAddress ?? "123 Main Way"
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
    private var _startDate: Date!
    private var _endDate: Date!
    
    var createdDate: Date {
        return _createdDate
    }
    
    var eventStartDate: Date {
        return _startDate ?? Date()
    }
    
    var eventEndDate: Date {
        return _endDate ?? Date()
    }
    
    // event invitees
    private var _invitees: [User]!
    private var _yesGoing: [User]!
    private var _noGoing: [User]!
    private var _maybeGoing: [User]!
    
    var eventInvitees: [User] {
        return _invitees ?? []
    }

    var yesGoing: [User] {
        return _yesGoing ?? []
    }

    var noGoing: [User] {
        return _noGoing ?? []
    }

    var maybeGoing: [User] {
        return _maybeGoing ?? []
    }

    
    // event assets
    private var _galleryId: String!
    private var _eventImageUrl: URL?
    
    var eventGalleryId: String {
        return _galleryId ?? ""
    }
    
    var eventImageUrl: URL {
        return _eventImageUrl ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/recreo-d1441.appspot.com/o/events%2Fevent4_bg.jpg?alt=media&token=4c269182-f632-4277-8af0-a57ebf79b3f4")!
    }
    
    init(eventId: String, eventHost: User) {
        print("AVINASH: Event pass with init of id and host")
        self._eventId = eventId
        self._eventHost = eventHost
    }
    
    init(eventName: String, host: User, createdDate: Date, eventDate: Date, address: String) {
        self._eventName = eventName
        self._eventHost = host
        self._createdDate = createdDate
        self._eventAddress = address
    }

    
    init(eventId: String, eventData: Dictionary<String, Any>, user: User) {
        print("AVINASH: Event pass with init of eventDict")
        self._eventId = eventId

        if let eventName = eventData["eventName"] as? String {
            self._eventName = eventName
        }

//        if let userKey = eventData["eventHost"] as? String {
//            print("AVINASH: Event pass with init of eventDict, calling User init of userId and firstName")
//            var user = User(userId: userKey, firstName: "Dino")
//            
//            let usersRef = FIRDatabase.database().reference().child("Users")
//            let userRef = usersRef.child(userKey)
//            print("AVINASH: \(userRef)")
//            
//            userRef.observe(.value, with: { (snapshot) in
//                print("AVINASH: \(snapshot.key)")
//                print("AVINASH: \(snapshot.value)")
//                if let userDict = snapshot.value! as? Dictionary<String, Any> {
//                    let id = snapshot.key
//                    print("AVINASH: Event pass with init of eventDict, calling User init of userDict")
//                    user = User(userId: id, userData: userDict)
//                }
//            }, withCancel: { error in
//                print(error.localizedDescription)
//            })
        self._eventHost = user
//        }

        if let createdDate = eventData["created"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

            self._createdDate = dateFormatter.date(from: createdDate)
        }

        if let startDate = eventData["startDate"] as? String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            self._startDate = dateFormatter.date(from: startDate)
        }
        
        let eventImageUrlString = eventData["imageUrl"] as? String
        if let eventImageUrlString = eventImageUrlString{
            self._eventImageUrl = URL(string: eventImageUrlString)
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
            print("AVINASH: Just checking on the zip")
        }

    }
}
