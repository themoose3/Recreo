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
        let event = events[indexPath.row]

        if event.eventImageUrl != "" {
            let cell = Bundle.main.loadNibNamed("EventCellWithoutImage", owner: self, options: nil)?.first as! EventCellWithoutImage
            
            //let event = events[indexPath.row]
            cell.event = event
            
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("EventCellWithImage", owner: self, options: nil)?.first as! EventCellWithImage
            
            //let event = events[indexPath.row]
            cell.event = event
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "EventDetailSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = events[indexPath.row]
    
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
            let event = events[row]
            eventDetailVC.event = event
        }
    }
    
}
