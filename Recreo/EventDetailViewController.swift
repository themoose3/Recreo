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
import AFNetworking

class EventDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var noCountLabel: UILabel!
    @IBOutlet weak var yesCountLabel: UILabel!
    @IBOutlet weak var eventDetailImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventMonthLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDayDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventVenueLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var event: Event? {
        didSet {
            print("AVINASH: Event name: \(event?.eventId ?? "no event id")")
            //print("AVINASH: Event image: \(event?.eventImageUrl ?? nil)")
            
        }
    }
    //setting default location to Mountain View, CA and region radius to show 5km
    let defaultLocation = CLLocation(latitude: 37.3861, longitude: -122.0839)
    let regionRadius: CLLocationDistance = 5000
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = event?.eventName
        
        print("Event id: \((event?.eventId)!)")
        
        if let eventId = event?.eventId {
            DataService.ds.REF_EVENTS.child(eventId).child("rsvps").observe(.value, with: { (snapshot) in
                print("Snapshot: \(snapshot)")
                print("AVINASH: REF_EVENTS_RSVP observe\n")
                if let snapshot = snapshot.value as? [String : String] {
                    var yesCounter = 0
                    var noCounter = 0
                    for (_, value) in snapshot {
                        if value == "yes" {
                            yesCounter += 1
                        } else if value == "no" {
                            noCounter += 1
                        } else {
                            print("Error: Malformed RSVP response.")
                        }
                    }
                    self.yesCountLabel.text = String(describing: yesCounter)
                    self.noCountLabel.text = String(describing: noCounter)
                }
            })
        }

        
        
        //get current location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //event image
        //eventDetailImageView.image = nil
        if let imageUrl = event?.eventImageUrl {
            eventDetailImageView.setImageWith(imageUrl)
        }
        
        //event date time handling
        let dateFormatter = DateFormatter()
        
        var startTimeString = ""
        var endTimeString = ""
        
        dateFormatter.dateFormat = "MMM"
        if let startDate = event?.eventStartDate {
            let monthString = dateFormatter.string(from: startDate)
            eventMonthLabel.text = monthString.uppercased()
            
            dateFormatter.dateFormat = "EEEE, MMM d"
            let dayDateString = dateFormatter.string(from: startDate)
            eventDayDateLabel.text = dayDateString
            
            dateFormatter.dateFormat = "h:mm a"
            startTimeString = dateFormatter.string(from: startDate)
        }
        if let endDate = event?.eventEndDate {
            dateFormatter.dateFormat = "dd"
            let dateString = dateFormatter.string(from: endDate)
            eventDateLabel.text = dateString.uppercased()
            endTimeString = dateFormatter.string(from: endDate)
        }
        eventTimeLabel.text = "\(startTimeString) - \(endTimeString)"
        
        //event name
        eventDescriptionLabel.text = event?.eventName
        
        //event address
        if let venue = event?.eventVenue {
            eventVenueLabel.text = venue
        }
        if let address = event?.eventAddress {
            
            if let city = event?.eventCity {
                
              if let state = event?.eventState {
                eventAddressLabel.text = "\(address), \(city), \(state)"
                //setup map view
                let eventLocation = getLocation(cityState: "\(city), \(state)")
                centerMapOnLocation(location: eventLocation)
                }
            }
        } else {
            eventAddressLabel.text = ""
        }
        
    }
    
    func getLocation(cityState: String) -> CLLocation {
        var someLocation: CLLocation = defaultLocation
        CLGeocoder().geocodeAddressString(cityState, completionHandler: { (placemarks, error) in
            if let placemarks = placemarks {
                if (placemarks.count) > 0 {
                    let placemark = placemarks.first
                    let annotation = MKPlacemark(placemark: placemark!)
                    self.mapView.addAnnotation(annotation)
                    let coordinate = placemark?.location?.coordinate
                    print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                    someLocation = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                }
            }
        })
        return someLocation
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error.localizedDescription)")
    }
    
    @IBAction func onDiscussionTap(_ sender: Any) {
        performSegue(withIdentifier: "ChatSegue", sender: self)
    }
    
    @IBAction func onGalleryTap(_ sender: Any) {
        performSegue(withIdentifier: "GallerySegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GallerySegue" {
            //let galleryVC = segue.destination as! GalleryViewController
        }
        if segue.identifier == "ChatSegue" {
            let navigationController = segue.destination as! UINavigationController
            let chatVC = navigationController.topViewController as! ChatViewController
            chatVC.eventRef = FIRDatabase.database().reference().child("Events").child((event?.eventId)!)
            chatVC.event = event
            
        }
    }

}
