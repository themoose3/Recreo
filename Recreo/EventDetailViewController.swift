//
//  EventDetailViewController.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import CoreLocation
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

    override func viewDidLoad() {
        super.viewDidLoad()
        //let invitees = ["+14088074454": name1, "+14151234567": name2, "+15302345678": name3]
        setupDetails()
        
        
        
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(address) { (placemarks, error) in
//            guard
//                let placemarks = placemarks,
//                let location = placemarks.first?.location
//                else {
//                    // handle no location found
//                    return
//            }
//            
            // Use your location
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy/MM/dd HH:mm"
//            let startDate = formatter.date(from: "2017/05/17 20:00")
//            let endDate = formatter.date(from: "2017/05/17 23:00")
            
//            // File located on disk
//            let localFile = URL(string: "Assets.xcassets/housewarming.jpg")!
//            
//            // Create a reference to the file you want to upload
//            let storageRef = storage.reference()
//            let riversRef = storageRef.child("images/rivers.jpg")
//            
//            // Upload the file to the path "images/rivers.jpg"
//            let uploadTask = riversRef.putFile(localFile, metadata: nil) { metadata, error in
//                if let error = error {
//                    // Uh-oh, an error occurred!
//                } else {
//                    // Metadata contains file metadata such as size, content-type, and download URL.
//                    let downloadURL = metadata!.downloadURL()
//                }
//            }
//            
            
//            let event:[String : AnyObject] = [
//                "eventName": eventName as AnyObject,
//                "eventDescription": eventDescription as AnyObject,
//                "host": host as AnyObject,
//                "invitees": invitees as AnyObject,
//                "venue": venue as AnyObject,
//                //"venueCoords": [location] as AnyObject,
//                "created": created as AnyObject,
//                "startDate": "2017/05/17 20:00" as AnyObject,
//                "endDate": "2017/05/17 23:00" as AnyObject,
//                "address": address as AnyObject
//                //"gallery": false as AnyObject,
//                //"eventImage": false as AnyObject
//            ]
//            
//            //To create Locations
//            let firebaseRef = FIRDatabase.database().reference()
//            firebaseRef.child("Events").childByAutoId().setValue(event)
        
        //}
        
        // Do any additional setup after loading the view.

    }
    
    func setupDetails() {
        // Set address label and pin for map view
        let address = "1 Infinite Loop, Cupertino, CA 95014"
        eventAddressLabel.text = address
        setPin(address: address)
        
        // Set event name and description
        eventDescriptionLabel.text = eventDescription
        eventNameLabel.text = eventName
        
        // Set date and time labels
        //parseDateAndTime(start: startDate, end: endDate)
    }
    
//    func parseDateAndTime(start: String, end: String) {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
//        if let date = dateFormatter.date(from: start) {
//            let calendar = Calendar.current
//            let month = calendar.component(.month, from: date)
//            let day = calendar.component(.day, from: date)
//            let hour = calendar.component(.hour, from: date)
//            let minutes = calendar.component(.minute, from: date)
//            
//            //monthLabel.text = month
//            
//        }
//    }
    
    func setPin (address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
