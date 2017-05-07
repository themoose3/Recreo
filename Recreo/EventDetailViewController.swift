//
//  EventDetailViewController.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var numberGoingLabel: UILabel!
    @IBOutlet weak var numberMaybeLabel: UILabel!
    @IBOutlet weak var numberNotGoingLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    
    
    // var eventId: Int
    let eventName = "Dino's Housewarming"
    let eventDescription = "Join me at my new digs on June 8. Bring your appetite!"
    let host = "2B8fkHDRikblHTrJdF8vQB320j02"
    let name1 = "Angie"
    let name2 = "Avinash"
    let name3 = "Sideok"
    let venue = "Dino's Digs"
    //        let created = String(describing: Date())
    //        let eventDate = "2017/05/17 23:00"
    // let startDate = "2017/05/17 20:00"
    // let endDate = "2017/05/17 23:00"
    // var galleryId: Gallery?
    // var eventImage: URL?
    var event: Event? {
        didSet {
        
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GallerySegue" {
            //let galleryVC = segue.destination as! GalleryViewController
        }
        if segue.identifier == "ChatSegue" {
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
