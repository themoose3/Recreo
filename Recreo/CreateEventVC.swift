//
//  CreateEventVC.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/15/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase
import ContactsUI
import Alamofire

class CreateEventVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var eventNameTextField: LoginTextField!
    @IBOutlet weak var eventLocationTextField: LoginTextField!
    @IBOutlet weak var tableView: UITableView!
    
    let firebaseDatabaseReference = FIRDatabase.database().reference()
    var invitedContacts:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
//        eventNameTextField.attributedPlaceholder =
//            NSAttributedString(string: "Event name",
//                             attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
//        eventLocationTextField.attributedPlaceholder =
//            NSAttributedString(string: "Event location",
//                               attributes: [NSForegroundColorAttributeName: UIColor.darkGray])

    }
    
    @IBAction func onCreateTap(_ sender: UITapGestureRecognizer) {
        let defaults = UserDefaults.standard
        let uid = defaults.string(forKey: "User")
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from:date)
        let createdTime = "\(year)/\(month)/\(day) \(hour):\(minutes):\(seconds)"
        
        var eventDetail:[String:String] = [:]
        eventDetail["eventName"] = eventNameTextField.text
        eventDetail["address"] = eventLocationTextField.text
        eventDetail["eventHost"] = uid
        eventDetail["createdTime"] = createdTime
        eventDetail["imageUrl"] = ""
        
        var eventDetailContacts:[String:String] = [:]
        if self.invitedContacts.count > 0 {
            for contact in self.invitedContacts{
                let contactInfo = contact.components(separatedBy: ",")
                eventDetailContacts[contactInfo.last!] = contactInfo.first!
            }
            eventDetailContacts["+14088074454"] = "Angie"
        }

        let firebaseDatabaseReference = FIRDatabase.database().reference()
        let eventRef = firebaseDatabaseReference.child("Events")
        
        let newEventKey = eventRef.childByAutoId().key
        let eventUniqueKey = eventRef.child(newEventKey)
        eventUniqueKey.setValue(eventDetail)
        eventUniqueKey.child("invitees").setValue(eventDetailContacts)
        print("AVINASH: insertion is completed")
        
        let addEventsToTheUser = firebaseDatabaseReference.child("users").child(uid!).child("events").child("hosting")
        addEventsToTheUser.setValue([newEventKey : true])
        self.sendInvites(eventId: newEventKey)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelTap(_ sender: UITapGestureRecognizer) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnInviteesTap(_ sender: Any) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCreateEventCell") as! NewCreateEventCell
        let contactInfo = invitedContacts[indexPath.row].components(separatedBy: ",")
        cell.invitedUserNameLabel.text = contactInfo.first
        cell.invitedUserPhoneNumberLabel.text = contactInfo.last
        
        //cell.textLabel?.text = "Row \(indexPath)"
        
        return cell
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
                body = "\(username) invited you to \(eventName).\r Can you make it? Reply YES, MAYBE, or NO"
                
                let headers = ["Content-Type": "application/x-www-form-urlencoded"]
                let parameters: Parameters = [
                    "To": "+18052186993",
                    "Body": body ?? "You're invited!",
                    "EventId": eventId,
                    "InviteeName": "Avinash P."
                ]
                
                Alamofire.request("https://c481e0b0.ngrok.io/sms", method: .post, parameters: parameters, headers: headers).response { response in
                    print(response)
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    

}
