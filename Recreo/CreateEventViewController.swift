//
//  CreateEventViewController.swift
//  Recreo
//
//  Created by sideok you on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase
import ContactsUI
import MBProgressHUD
import Alamofire

class CreateEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var venueField: UITextField!
  @IBOutlet weak var eventTitleField: UITextField!
  @IBOutlet weak var eventStartPickerField: UITextField!
  @IBOutlet weak var eventEndPickerField: UITextField!
  @IBOutlet weak var eventDescriptionField: UITextField!
  @IBOutlet weak var addressField: UITextField!
  @IBOutlet weak var cityField: UITextField!
  @IBOutlet weak var stateField: UITextField!
  @IBOutlet weak var zipField: UITextField!
  @IBOutlet weak var pickedImage: UIImageView!
  
  @IBOutlet weak var tableView: UITableView!

  let firebaseDatabaseReference = FIRDatabase.database().reference()
  
  var invitedContacts:[String] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.dataSource = self
        tableView.delegate = self
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @IBAction func onAddPhotosButton(_ sender: Any) {
    
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    
    let actionSheet = UIAlertController(title: "Upload photos", message: "Choose a source", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
      
      if UIImagePickerController.isSourceTypeAvailable(.camera){
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated:true, completion: nil)
      }else{
        print("Camera not available")
      }
      
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
      imagePickerController.sourceType = .photoLibrary
      imagePickerController.allowsEditing = false
      self.present(imagePickerController, animated:true, completion: nil)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    
    self.present(actionSheet, animated:true, completion: nil)
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
      pickedImage.image = image
    }else{
      print("wrong")
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
    self.dismiss(animated: true, completion: nil)
  }
 
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //we should return count of returned dictionary from ContactListController
    if invitedContacts.count == 0{
      return 0
    }else{
      return invitedContacts.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // we do not need to do anything in here because the goal is to show invited contact list from user
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell") as! ContactListCell
    let contactInfo = invitedContacts[indexPath.row].components(separatedBy: ",")
    cell.invitedUserLabel.text = contactInfo.first
    cell.invitedUserPhoneNumberLabel.text = contactInfo.last
    
    return cell
    
  }
  @IBAction func onCreateButton(_ sender: Any) {
    
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    //needs to store all input values to firebase database
    let imageName = NSUUID().uuidString
    let storageRef = FIRStorage.storage().reference().child("event_images").child("\(imageName).png")
    
    if let uploadData = UIImagePNGRepresentation(self.pickedImage.image!){
       storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
        
        if error != nil{
          print(error ?? "Error with uploading image")
          return
        }
        
        let defaults = UserDefaults.standard
        let uid = defaults.object(forKey: "User") as! String
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from:date)
        let created_time = "\(year)/\(month)/\(day) \(hour):\(minutes):\(seconds)"
        
        if let eventImageUrl = metadata?.downloadURL()?.absoluteString{
          
          var eventDetail:[String:String] = [:]
          
          
          eventDetail["address"] = self.addressField.text
          eventDetail["city"] = self.cityField.text
          eventDetail["state"] = self.stateField.text
          eventDetail["zip"] = self.zipField.text
          eventDetail["created"] = created_time
          eventDetail["endDate"] = self.eventEndPickerField.text
          eventDetail["startDate"] = self.eventStartPickerField.text
          eventDetail["eventDescription"] = self.eventDescriptionField.text
          eventDetail["eventHost"] = uid
          eventDetail["eventName"] = self.eventTitleField.text
          eventDetail["imageUrl"] = eventImageUrl
          eventDetail["venue"] = self.venueField.text
          
          var eventDetailContacts:[String:String] = [:]
          
          if self.invitedContacts.count != 0{
            for contact in self.invitedContacts{
              let contactInfo = contact.components(separatedBy: ",")
              eventDetailContacts[contactInfo.last!] = contactInfo.first!
            }
            eventDetailContacts["+14088074454"] = "Angie"
          }
          
          let firebaseDatabaseReference = FIRDatabase.database().reference()
          let eventReferenceWithEventId = firebaseDatabaseReference.child("Events")
          
          let newKey = eventReferenceWithEventId.childByAutoId().key
          
          let eventUniqueKey = eventReferenceWithEventId.child(newKey)
          eventUniqueKey.setValue(eventDetail)
          eventUniqueKey.child("invitees").setValue(eventDetailContacts)
          
          print("insertion is completed")
          
          let addEventsToTheUser = firebaseDatabaseReference.child("users").child(uid).child("events").child("hosting")
          
          addEventsToTheUser.setValue([newKey : true])
          self.sendInvites(eventId: newKey)
          
          MBProgressHUD.hide(for: self.view, animated: true)
          
          self.dismiss(animated: true, completion: nil)
        }
        
       })
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerForPushNotifications(application: UIApplication.shared)
    }
  }
  
  @IBAction func onCancelButton(_ sender: Any) {
    print("cancel")
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onPickEndDateField(_ sender: UITextField) {
    let datePickerView: UIDatePicker = UIDatePicker()
    datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
    sender.inputView = datePickerView
    datePickerView.addTarget(self, action: #selector(CreateEventViewController.endDatePickerValueChanged), for: UIControlEvents.valueChanged)
  }
  
  func endDatePickerValueChanged(sender:UIDatePicker){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    let newDate = dateFormatter.string(from:sender.date)
    eventEndPickerField.text = newDate
    
  }
  
  @IBAction func onPickStartDateField(_ sender: UITextField) {
    
    let datePickerView: UIDatePicker = UIDatePicker()
    datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
    sender.inputView = datePickerView
    datePickerView.addTarget(self, action: #selector(CreateEventViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
  }
  
  func datePickerValueChanged(sender:UIDatePicker){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    let newDate = dateFormatter.string(from:sender.date)
    eventStartPickerField.text = newDate
    
  }
  
  @IBAction func onInviteFriendButton(_ sender: Any) {
    //needs to call ContactListController
    let cnPicker = CNContactPickerViewController()
    cnPicker.delegate = self
    self.present(cnPicker, animated:true, completion: nil)
    
  }
  
  func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
    
    invitedContacts = []
    
    contacts.forEach { (contact:CNContact) in
      
      var phoneNumber:String = "";
      for number in contact.phoneNumbers{
        
        if number.label == CNLabelPhoneNumberiPhone {
          //iPhone number.
          phoneNumber = number.value.stringValue
          invitedContacts.append(contact.givenName+","+phoneNumber)
          print("1")
        } else if number.label == CNLabelPhoneNumberMobile {
          //Mobile phone number.
          phoneNumber = number.value.stringValue
          invitedContacts.append(contact.givenName+","+phoneNumber)
          break
        } else if number.label == CNLabelPhoneNumberMain {
          //Main phone number.
          phoneNumber = number.value.stringValue
          invitedContacts.append(contact.givenName+","+phoneNumber)
          break
        } else if number.label == CNLabelPhoneNumberHomeFax {
          //Home fax number.
          print("4")
          
        } else if number.label == CNLabelPhoneNumberWorkFax {
          //Work fax number.
          print("5")
        } else if number.label == CNLabelPhoneNumberOtherFax {
          //Other fax number.
          print("6")
        } else if number.label == CNLabelPhoneNumberPager {
          //Pager phone number.
          print("7")
        } else {
          // Custome Phone Number
          // number.label -> to get custome label name
          phoneNumber = number.value.stringValue
          invitedContacts.append(contact.givenName+","+phoneNumber)
          break
        }
        
      }
      
    }
       tableView.reloadData()
  }
  
  func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
    print("cancel contact picker")
  }
  func sendInvites(eventId: String) {

    var body: String?
    print("I'm hereee")

    firebaseDatabaseReference.child("Events").child(eventId).observeSingleEvent(of: .value, with: { (snapshot) in
    // Get user value
      let value = snapshot.value as? NSDictionary
      let userId = value?["eventHost"] as? String ?? ""
      let eventName = value?["eventName"] as? String ?? ""

   self.firebaseDatabaseReference.child("Users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
         let value = snapshot.value as? NSDictionary
         let firstName = value?["firstName"] as? String ?? ""
         let lastName = value?["lastName"] as? String ?? ""
         let username = firstName + lastName
         body = "\(username) invited you to \(eventName).\r Can you make it? Reply YES or NO"

        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters: Parameters = [
          "To": "+14088074454",
          "Body": body ?? "You're invited!",
          "EventId": eventId,
          "InviteeName": "Angie"
        ]

        Alamofire.request("https://3ed871e6.ngrok.io/sms", method: .post, parameters: parameters, headers: headers).response { response in
          print(response)

        }
      }) { (error) in
        print(error.localizedDescription)
      }
    }) { (error) in
      print(error.localizedDescription)
    }
  }
//  func addPhoneNumber(phNo : String) {
//    if #available(iOS 9.0, *) {
//      let store = CNContactStore()
//      let contact = CNMutableContact()
//      let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :phNo ))
//            contact.phoneNumbers = [homePhone]
//      let controller = CNContactViewController(forUnknownContact : contact)// .viewControllerForUnknownContact(contact)
//      controller.contactStore = store
//      controller.delegate = self
//      self.navigationController?.setNavigationBarHidden(false, animated: true)
//      self.navigationController!.pushViewController(controller, animated: true)
//        }
//    }
}
