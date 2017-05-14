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
            print("AVINASH: Event name: \(event?.eventId ?? "no event name")")
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
        
        //get current location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //event image
        eventDetailImageView.image = nil
        eventDetailImageView.setImageWith((event?.eventImageUrl)!)
        
        //event date time handling
        let eventStartDate = event?.eventStartDate
        let eventEndDate = event?.eventEndDate
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM"
        let monthString = dateFormatter.string(from: eventStartDate!)
        eventMonthLabel.text = monthString.uppercased()
        
        dateFormatter.dateFormat = "dd"
        let dateString = dateFormatter.string(from: eventStartDate!)
        eventDateLabel.text = dateString.uppercased()
        
        dateFormatter.dateFormat = "EEEE, MMM d"
        let dayDateString = dateFormatter.string(from: eventStartDate!)
        eventDayDateLabel.text = dayDateString
        
        dateFormatter.dateFormat = "h:mm a"
        let startTimeString = dateFormatter.string(from: eventStartDate!)
        let endTimeString = dateFormatter.string(from: eventEndDate!)
        eventTimeLabel.text = "\(startTimeString) - \(endTimeString)"
        
        //event name
        eventDescriptionLabel.text = event?.eventName
        
        //event address
        eventVenueLabel.text = event?.eventVenue
        eventAddressLabel.text = "\((event?.eventAddress)!), \((event?.eventCity)!), \((event?.eventState)!)"
        
        //setup map view
        let eventLocation = getLocation(cityState: "\((event?.eventCity)!), \((event?.eventState)!)")
        centerMapOnLocation(location: eventLocation)
    }
    
    func getLocation(cityState: String) -> CLLocation {
        var someLocation: CLLocation = defaultLocation
        CLGeocoder().geocodeAddressString(cityState, completionHandler: { (placemarks, error) in
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?.first
                let annotation = MKPlacemark(placemark: placemark!)
                self.mapView.addAnnotation(annotation)
                let coordinate = placemark?.location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                someLocation = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
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
