//
//  EventsFeedViewController.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EventsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventsSegmentedControl: UISegmentedControl!
    
    var event: Event!
    var events = [Event]()
    var hostedEvents = [Event]()
    var invitedToEvents = [Event]()
    var shownEvents = [Event]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let currentUserUID = KeychainWrapper.standard.string(forKey: KEY_UID)

        DataService.ds.REF_USERS.observe(.value, with: { (snapshot) in
            print("AVINASH: REF_USERS observe\n")
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("AVINASH: Users table, \(snap.key)")
                    if let userDict = snap.value! as? Dictionary<String, Any> {
                        let id = snap.key
                        let user = User(userId: id, userData: userDict)
                        print(user.firstName)
                        self.users.append(user)
                    }
                }
            }
        })
        
        DataService.ds.REF_EVENTS.observe(.value, with: { (snapshot) in
            print("AVINASH: REF_EVENTS observe\n")
            self.events.removeAll()
            self.shownEvents.removeAll()
            self.hostedEvents.removeAll()
            self.invitedToEvents.removeAll()
            
            print("AVINASH: remove events")
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("AVINASH: Events table, \(snap.key)")
                    if let eventDict = snap.value! as? Dictionary<String, Any> {
                        let id = snap.key
                        let eventHost = eventDict["eventHost"]
                        let userFromEventHost = self.getUserById(users: self.users, userId: eventHost as! String)
                        print("AVINASH: profile image url, \(userFromEventHost.profileImageUrl)")
                        print("AVINASH: sending to Event pass with id: \(id) and event host uid: \(eventHost!)")
                        let event = Event(eventId: id, eventData: eventDict, user: userFromEventHost)
                        self.events.append(event)
                        if(event.eventHost.userId == currentUserUID) {
                            self.hostedEvents.append(event)
                            self.shownEvents.append(event)
                        }
                        //print("SNAPPY: \(event.eventName)")
                        //print("SNAPPY EVENT COUNT: \(self.events.count)")
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    private func getUserById(users: [User], userId: String) -> User {
        for user in users {
            if user.userId == userId {
                return user
            }
        }
        return User(userId: "DummyUser", firstName: "Dummy")
    }
    
    @IBAction func onSegmentChange(_ sender: Any) {
        switch eventsSegmentedControl.selectedSegmentIndex {
        case 0:
            shownEvents = hostedEvents
        case 1:
            shownEvents = invitedToEvents
        default:
            shownEvents = events
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = shownEvents[indexPath.row]
        
        if event.eventImageUrl == nil {
        //if event.eventImageUrl != "" {
            let cell = Bundle.main.loadNibNamed("EventCellWithoutImage", owner: self, options: nil)?.first as! EventCellWithoutImage
            cell.event = event
            
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("EventCellWithImage", owner: self, options: nil)?.first as! EventCellWithImage
            cell.event = event
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "EventDetailSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = shownEvents[indexPath.row]
    
        if event.eventImageUrl == nil {
            return 202
        } else {
            return 312
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailSegue" {
            let navigationController = segue.destination as! UINavigationController
            let eventDetailVC = navigationController.topViewController as! EventDetailViewController
            let row = (sender as! IndexPath).row
            let event = shownEvents[row]
            eventDetailVC.event = event
        }
    }
    
}
