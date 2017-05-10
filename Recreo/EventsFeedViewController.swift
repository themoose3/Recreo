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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.register(UINib(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        
        let currentUserUID = KeychainWrapper.standard.string(forKey: KEY_UID)
        DataService.ds.REF_EVENTS.observe(.value, with: { (snapshot) in
            self.events.removeAll()
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let eventDict = snap.value! as? Dictionary<String, Any> {
                        let id = snap.key
                        let event = Event(eventId: id, eventData: eventDict)
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

        if event.eventImageUrl != "" {
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
    
        if event.eventImageUrl != "" {
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
