//
//  EventCell.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/13/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import AFNetworking
import Firebase
import SwiftKeychainWrapper

class EventCell: UITableViewCell {

    @IBOutlet weak var eventBackgroundImageView: UIImageView!
    @IBOutlet weak var eventHostNameLabel: UILabel!
    @IBOutlet weak var eventHostProfileImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    
    @IBOutlet weak var yesGoingImageView: UIImageView!
    @IBOutlet weak var notGoingImageView: UIImageView!
    
    var goingYesReference: FIRDatabaseReference!
    var goingNoReference: FIRDatabaseReference!
    var eventHostProfileImg: UIImage?
    var eventBackgroundImg: UIImage?
    
    var event: Event! {
        didSet {
            eventHostNameLabel.text = "\(event.eventHost.firstName) \(event.eventHost.lastName)"
            
            //eventHostProfileImageView.image = nil
            //eventHostProfileImageView.setImageWith(event.eventHost.profileImageUrl)
            let profileRef = FIRStorage.storage().reference(forURL: "\(event.eventHost.profileImageUrl)")
            if eventHostProfileImg != nil {
                eventHostProfileImageView.image = eventHostProfileImg
                print("AVINASH: Using profile image in cache")
            } else {
                profileRef.data(withMaxSize: 30 * 1024 * 1024) { (data, error) in
                    if error != nil {
                        print("AVINASH: Unable to download profile image from Firebase storage")
                    } else {
                        print("AVINASH: Profile Image downloaded from Firebase storage")
                        if let eventHostProfileImgData = data {
                            if let eventHostProfileImg = UIImage(data: eventHostProfileImgData) {
                                self.eventHostProfileImageView.image = eventHostProfileImg
                                EventsFeedVC.imageCache.setObject(eventHostProfileImg, forKey: self.event.eventHost.profileImageUrl.path as NSString)
                            }
                        }
                    }
                }
            }
            
            eventNameLabel.text = event.eventName
            
            let eventDate = event.eventStartDate
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMM"
            let monthString = dateFormatter.string(from: eventDate)
            dateFormatter.dateFormat = "dd"
            let dateString = dateFormatter.string(from: eventDate)
            dateFormatter.dateFormat = "h:mm a"
            let timeString = dateFormatter.string(from: eventDate)
            eventDateTimeLabel.text = "\(monthString) \(dateString) \(timeString)"

            //eventBackgroundImageView.image = nil
            //eventBackgroundImageView.setImageWith(event.eventImageUrl)
            let bgRef = FIRStorage.storage().reference(forURL: "\(event.eventImageUrl)")
            if eventBackgroundImg != nil {
                eventBackgroundImageView.image = eventBackgroundImg
                print("AVINASH: Using bg image in cache")
            } else {
                bgRef.data(withMaxSize: 30 * 1024 * 1024) { (data, error) in
                    if error != nil {
                        print("AVINASH: Unable to download BG image from Firebase storage")
                    } else {
                        print("AVINASH: BG Image downloaded from Firebase storage")
                        if let eventBackgroundImgData = data {
                            if let eventBackgroundImg = UIImage(data: eventBackgroundImgData) {
                                self.eventBackgroundImageView.image = eventBackgroundImg
                                EventsFeedVC.imageCache.setObject(eventBackgroundImg, forKey: self.event.eventImageUrl.path as NSString)
                            }
                        }
                    }
                }
            }

            
            
            let currentUser = KeychainWrapper.standard.string(forKey: KEY_UID)
            goingYesReference = DataService.ds.REF_EVENTS.child(event.eventId).child("yesGoing").child(currentUser!)
            goingNoReference = DataService.ds.REF_EVENTS.child(event.eventId).child("noGoing").child(currentUser!)

            //set initial state when the table view loads
            yesGoingImageView.isHidden = true
            notGoingImageView.isHidden = true
            goingYesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.yesGoingImageView.image = UIImage(named: "GoingNotSelectedImage")
                } else {
                    self.yesGoingImageView.image = UIImage(named: "GoingImage")
                }
            })
            
            goingNoReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.notGoingImageView.image = UIImage(named: "NotGoingNotSelectedImage")
                } else {
                    self.notGoingImageView.image = UIImage(named: "NotGoingImage")
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

    }
    
    func onTapYes(_ sender: UITapGestureRecognizer) {
        //change the state for yes button when tapped, turn off for remaining buttons
        goingYesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.yesGoingImageView.image = UIImage(named: "GoingImage")
                self.goingYesReference.setValue(true)
            } else {
                self.yesGoingImageView.image = UIImage(named: "GoingNotSelectedImage")
                self.goingYesReference.removeValue()
            }
            self.notGoingImageView.image = UIImage(named: "NotGoingNotSelectedImage")
            self.goingNoReference.removeValue()
            //self.maybeGoingImageView.image = UIImage(named: "maybe-not-selected")
            //self.goingMaybeReference.removeValue()
        })
    }

    func onTapNo(_ sender: UITapGestureRecognizer) {
        //change the state for no button when tapped, turn off for remaining buttons
        goingNoReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.notGoingImageView.image = UIImage(named: "NotGoingImage")
                self.goingNoReference.setValue(true)
            } else {
                self.notGoingImageView.image = UIImage(named: "NotGoingNotSelected")
                self.goingNoReference.removeValue()
            }
            self.yesGoingImageView.image = UIImage(named: "GoingNotSelectedImage")
            self.goingYesReference.removeValue()
            //self.maybeGoingImageView.image = UIImage(named: "maybe-not-selected")
            //self.goingMaybeReference.removeValue()
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
