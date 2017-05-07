//
//  EventsFeedViewController.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit

class EventsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("EventCell", owner: self, options: nil)?.first as! EventCell
        cell.eventLabel.text = "row \(indexPath.row)"
        
        return cell
    }
    
    //init(userId: Int, email: String, phoneNumber: String) {
    //init(eventId: Int, eventName: String, host: User, created: Date, startTime: Date) {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = User(userId: "epkM4f0wwbZTz97U3uhvMzW7UWl2", email: "avinash@gmail.com", phoneNumber: "1234567890")
        let createdTime = Date()
        //let interval = TimeInterval(60*60*24*indexPath.row)
        //let startTime = createdTime.addingTimeInterval(interval)
            event = Event(eventId: "KjRdocp00UXRPhnaZeF", eventName: "Event", host: user, created: String(describing: createdTime), startDate: "2017/06/08 20:00", endDate: "2017/06/08 23:00", address: "185 Berry St., San Francisco, CA")
        
        performSegue(withIdentifier: "EventDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailSegue" {
            let eventDetailController = segue.destination as! EventDetailViewController
            eventDetailController.event = event
        }
    }
    
}
