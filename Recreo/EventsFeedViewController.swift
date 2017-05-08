//
//  EventsFeedViewController.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase

class EventsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var event: Event!
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        DataService.ds.REF_EVENTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let eventDict = snap.value! as? Dictionary<String, Any> {
                        let id = snap.key
                        let event = Event(eventId: id, eventData: eventDict)
                        self.events.append(event)
                        //print("SNAPPY: \(event.eventName)")
                        //print("SNAPPY EVENT COUNT: \(self.events.count)")
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("EventCellWithoutImage", owner: self, options: nil)?.first as! EventCellWithoutImage
        
        let event = events[indexPath.row]
        cell.event = event
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //let user = User(userId: "epkM4f0wwbZTz97U3uhvMzW7UWl2", email: "avinash@gmail.com")
        //let createdTime = Date()
        //let interval = TimeInterval(60*60*24*indexPath.row)
        //let eventTime = createdTime.addingTimeInterval(interval)
        //event = Event(eventName: "Event", host: user, createdDate: createdTime, eventDate: eventTime, address: "185 Berry St., San Francisco, CA")
        
        performSegue(withIdentifier: "EventDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailSegue" {
            let cell = sender as! EventCell
            let eventDetailController = segue.destination as! EventDetailViewController
            eventDetailController.event = cell.event
        }
    }
    
}
