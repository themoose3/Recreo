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


let offset_HeaderStop:CGFloat = 140.0 // At this offset the Header stops its transformations
let distance_W_LabelHeader:CGFloat = 30.0 // The distance between the bottom of the Header and the top of the White Label

class EventDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var noCountLabel: UILabel!
    @IBOutlet weak var yesCountLabel: UILabel!
    @IBOutlet weak var eventDetailImageView: UIImageView!
    @IBOutlet weak var eventAddressTextField: UITextField!
    //@IBOutlet weak var eventDateLabel: UILabel!
    //@IBOutlet weak var eventMonthLabel: UILabel!
    //@IBOutlet weak var eventDescriptionLabel: UILabel!
   // @IBOutlet weak var eventDayDateLabel: UILabel!
   // @IBOutlet weak var eventTimeLabel: UILabel!
   // @IBOutlet weak var eventVenueLabel: UILabel!
    //@IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    @IBOutlet weak var eventStartDateTextField: UITextField!
    var blurredHeaderImageView:UIImageView?
    
    //setting default location to Mountain View, CA and region radius to show 5km
    let defaultLocation = CLLocation(latitude: 37.3861, longitude: -122.0839)
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 200
    
    var eventName: String?

    var event: Event! {
        didSet {
            eventName = event?.eventName
            print(eventName!)
            print("AVINASH: Event ID: \(event?.eventId ?? "no event id")")
            
        }
    }
    var eventBackgroundImg: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        self.edgesForExtendedLayout = []
        headerLabel.isHidden = true
        eventDescriptionTextView.isHidden = true
        
        if eventName != nil {
            eventNameLabel.text = eventName!
        }
        //event description
       // eventDescriptionTextView.text = event?.eventDescription ?? "Give us the deets!"
        
        //event address
        eventAddressTextField.text = event?.eventAddress ?? "123 Main St., SF, CA 94101"
        mapView.showsUserLocation = true
        
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
                            self.rsvpButton.shake()
                            
                        } else if value == "no" {
                            noCounter += 1
                            self.rsvpButton.shake()
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
        
        let bgRef = FIRStorage.storage().reference(forURL: "\(event.eventImageUrl)")
        if eventBackgroundImg != nil {
            eventDetailImageView.image = eventBackgroundImg
            print("AVINASH: Using bg image in cache")
        } else {
            bgRef.data(withMaxSize: 10 * 1024 * 1024) { (data, error) in
                if error != nil {
                    print("AVINASH: Unable to download BG image from Firebase storage")
                } else {
                    print("AVINASH: BG Image downloaded from Firebase storage")
                    if let eventBackgroundImgData = data {
                        if let eventBackgroundImg = UIImage(data: eventBackgroundImgData) {
                            self.eventDetailImageView.image = eventBackgroundImg
                            EventsFeedVC.imageCache.setObject(eventBackgroundImg, forKey: self.event.eventImageUrl.path as NSString)
                        }
                    }
                }
            }
        }
        
        //event date time handling
//        let dateFormatter = DateFormatter()
//        
//        var startTimeString = ""
//        var endTimeString = ""
//        
//        dateFormatter.dateFormat = "MMM"
//        if let startDate = event?.eventStartDate {
//            let monthString = dateFormatter.string(from: startDate)
//            eventMonthLabel.text = monthString.uppercased()
//            
//            dateFormatter.dateFormat = "EEEE, MMM d"
//            let dayDateString = dateFormatter.string(from: startDate)
//            eventDayDateLabel.text = dayDateString
//            
//            dateFormatter.dateFormat = "h:mm a"
//            startTimeString = dateFormatter.string(from: startDate)
//        }
//        if let endDate = event?.eventEndDate {
//            dateFormatter.dateFormat = "dd"
//            let dateString = dateFormatter.string(from: endDate)
//            eventDateLabel.text = dateString.uppercased()
//            endTimeString = dateFormatter.string(from: endDate)
//        }
//        eventTimeLabel.text = "\(startTimeString) - \(endTimeString)"
        
        
        //event address
//        if let venue = event?.eventVenue {
//            eventVenueLabel.text = venue
//        }
//        if let address = event?.eventAddress {
//            
//            if let city = event?.eventCity {
//                
//                if let state = event?.eventState {
//                    eventAddressLabel.text = "\(address), \(city), \(state)"
//                    //setup map view
//                    let eventLocation = getLocation(cityState: "\(city), \(state)")
//                    centerMapOnLocation(location: eventLocation)
//                }
//            }
//        } else {
//            eventAddressLabel.text = ""
//        }
        
    }
    
    override func loadView() {
        Bundle.main.loadNibNamed("EventDetailViewController", owner: self, options: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Header - Image
        
        headerImageView = UIImageView(frame: header.bounds)
        if let imageUrl = event?.eventImageUrl {
            headerImageView?.setImageWith(imageUrl)
            
            //headerImageView?.image = UIImage(named: "header_bg")
            headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
            header.insertSubview(headerImageView, belowSubview: headerLabel)
            
            // Header - Blurred Image
            
            headerBlurImageView = UIImageView(frame: header.bounds)
            
            do {
                let image = UIImage(data: try Data(contentsOf: imageUrl))
                headerBlurImageView?.image = image?.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
            } catch let error {
                print("error occured \(error)")
            }
            headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
            headerBlurImageView?.alpha = 0.0
            header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
            
            header.clipsToBounds = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        print("Offest: \(offset)")
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            let alignToNameLabel = -offset + header.frame.height + offset_HeaderStop
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, eventNameLabel.frame.maxY - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - alignToNameLabel)/distance_W_LabelHeader)

            if eventNameLabel.frame.maxY - offset <= 20.0 {
                let fadeTextAnimation = CATransition()
                fadeTextAnimation.duration = 0.8
                fadeTextAnimation.type = kCATransitionFade
                
                navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
                if let name = eventName {
                    self.navigationController?.navigationBar.topItem?.title = name
                    eventNameLabel.isHidden = true
                    eventDescriptionTextView.isHidden = false
  
                }
            }
        }
        
        // Apply Transformations
        
        header.layer.transform = headerTransform
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
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
    @IBAction func onSave(_ sender: Any) {
        //Save fields to Firebase
    }
    
    @IBAction func onEventTimeButton(_ sender: UIButton) {
        sender.shake()
    }
    
    @IBAction func onStartDateTextField(_ sender: UITextField) {

    }
    
    @IBAction func onMapButton(_ sender: UIButton) {
        let eventLocation = getLocation(cityState: (event?.eventAddress)!)
        centerMapOnLocation(location: eventLocation)
        // Drop a pin at user's Current Location
        let eventAnnotation: MKPointAnnotation = MKPointAnnotation()
        eventAnnotation.coordinate = CLLocationCoordinate2DMake(eventLocation.coordinate.latitude, eventLocation.coordinate.longitude);
        eventAnnotation.title = "Current location"
        mapView.addAnnotation(eventAnnotation)
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

extension UIButton {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -3.0, 3.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}
