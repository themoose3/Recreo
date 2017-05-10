//
//  EventCellWithImage.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/6/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import AFNetworking
import Firebase
import SwiftKeychainWrapper

class EventCellWithImage: UITableViewCell {

    @IBOutlet weak var eventCellMessageLabel: UILabel!
    @IBOutlet weak var eventHostProfileImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventMonthLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDayTimeLocationLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var yesGoingImageView: UIImageView!
    @IBOutlet weak var notGoingImageView: UIImageView!
    @IBOutlet weak var maybeGoingImageView: UIImageView!
    
    var goingYesReference: FIRDatabaseReference!
    var goingNoReference: FIRDatabaseReference!
    var goingMaybeReference: FIRDatabaseReference!
    
    
    var event: Event! {
        didSet {
            eventCellMessageLabel.text = "\(event.eventHost.firstName) is hosting an event"
            
            let eventDate = event.eventStartDate
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMM"
            let monthString = dateFormatter.string(from: eventDate)
            eventMonthLabel.text = monthString.uppercased()
            
            dateFormatter.dateFormat = "dd"
            let dateString = dateFormatter.string(from: eventDate)
            eventDateLabel.text = dateString.uppercased()
            
            eventNameLabel.text = event.eventName
            
            dateFormatter.dateFormat = "E"
            let dayOfWeekString = dateFormatter.string(from: eventDate)
            dateFormatter.dateFormat = "h:mm a"
            let timeString = dateFormatter.string(from: eventDate)
            eventDayTimeLocationLabel.text = "\(dayOfWeekString) \(timeString) at \(event.eventVenue), \(event.eventCity) \(event.eventState)"
            
            if(event.eventHost.profileImageUrl != "") {
                let hostProfileImageUrl = URL(string: event.eventHost.profileImageUrl)
                eventHostProfileImageView.setImageWith(hostProfileImageUrl!)
            } else {
                eventHostProfileImageView.image = UIImage(named: "default_profile_image")
            }
            
            if(event.eventImageUrl != "") {
                let eventImageUrl = URL(string: event.eventImageUrl)
                eventImageView.setImageWith(eventImageUrl!)
            } else {
                eventImageView.image = UIImage(named: "default_event_image")
            }
            
            let currentUser = KeychainWrapper.standard.string(forKey: KEY_UID)
            goingYesReference = DataService.ds.REF_EVENTS.child(event.eventId).child("yesGoing").child(currentUser!)
            goingNoReference = DataService.ds.REF_EVENTS.child(event.eventId).child("noGoing").child(currentUser!)
            goingMaybeReference = DataService.ds.REF_EVENTS.child(event.eventId).child("maybeGoing").child(currentUser!)
            
            //set initial state when the table view loads
            goingYesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.yesGoingImageView.image = UIImage(named: "going-not-selected")
                } else {
                    self.yesGoingImageView.image = UIImage(named: "going-selected")
                }
            })
            
            goingNoReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.notGoingImageView.image = UIImage(named: "notgoing-not-selected")
                } else {
                    self.notGoingImageView.image = UIImage(named: "notgoing-selected")
                }
            })
            
            goingMaybeReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.maybeGoingImageView.image = UIImage(named: "maybe-not-selected")
                } else {
                    self.maybeGoingImageView.image = UIImage(named: "maybe-selected")
                }
            })

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapYes = UITapGestureRecognizer(target: self, action: #selector(onTapYes(_:)))
        tapYes.numberOfTapsRequired = 1
        yesGoingImageView.addGestureRecognizer(tapYes)
        yesGoingImageView.isUserInteractionEnabled = true
        
        let tapNo = UITapGestureRecognizer(target: self, action: #selector(onTapNo(_:)))
        tapNo.numberOfTapsRequired = 1
        notGoingImageView.addGestureRecognizer(tapNo)
        notGoingImageView.isUserInteractionEnabled = true
        
        let tapMaybe = UITapGestureRecognizer(target: self, action: #selector(onTapMaybe(_:)))
        tapMaybe.numberOfTapsRequired = 1
        maybeGoingImageView.addGestureRecognizer(tapMaybe)
        maybeGoingImageView.isUserInteractionEnabled = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onTapYes(_ sender: UITapGestureRecognizer) {
        //change the state for yes button when tapped, turn off for remaining buttons
        goingYesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.yesGoingImageView.image = UIImage(named: "going-selected")
                self.goingYesReference.setValue(true)
            } else {
                self.yesGoingImageView.image = UIImage(named: "going-not-selected")
                self.goingYesReference.removeValue()
            }
            self.notGoingImageView.image = UIImage(named: "notgoing-not-selected")
            self.goingNoReference.removeValue()
            self.maybeGoingImageView.image = UIImage(named: "maybe-not-selected")
            self.goingMaybeReference.removeValue()
        })
    }
    
    func onTapNo(_ sender: UITapGestureRecognizer) {
        //change the state for no button when tapped, turn off for remaining buttons
        goingNoReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.notGoingImageView.image = UIImage(named: "notgoing-selected")
                self.goingNoReference.setValue(true)
            } else {
                self.notGoingImageView.image = UIImage(named: "notgoing-not-selected")
                self.goingNoReference.removeValue()
            }
            self.yesGoingImageView.image = UIImage(named: "going-not-selected")
            self.goingYesReference.removeValue()
            self.maybeGoingImageView.image = UIImage(named: "maybe-not-selected")
            self.goingMaybeReference.removeValue()
        })
    }
    
    func onTapMaybe(_ sender: UITapGestureRecognizer) {
        //change the state for maybe button when tapped, turn off for remaining buttons
        goingMaybeReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.maybeGoingImageView.image = UIImage(named: "maybe-selected")
                self.goingMaybeReference.setValue(true)
            } else {
                self.maybeGoingImageView.image = UIImage(named: "maybe-not-selected")
                self.goingMaybeReference.removeValue()
            }
            self.yesGoingImageView.image = UIImage(named: "going-not-selected")
            self.goingYesReference.removeValue()
            self.notGoingImageView.image = UIImage(named: "notgoing-not-selected")
            self.goingNoReference.removeValue()
        })
    }
}
