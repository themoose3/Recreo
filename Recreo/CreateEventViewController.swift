//
//  CreateEventViewController.swift
//  Recreo
//
//  Created by sideok you on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ContactsUI

class CreateEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate {

  @IBOutlet weak var eventTitleField: UITextField!
  @IBOutlet weak var datePickerField: UITextField!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var eventContentField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  var invitedContacts:[String] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.dataSource = self
        tableView.delegate = self
      
      print("invitedContacts = \(invitedContacts)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //needs to store all input values to firebase database
    
    let ref = FIRDatabase.database().reference()
    //fake user id
    // we discussed that user id has to be user phone number
    let fake_user_id = "213-392-7840"
    let itemRef = ref.child(fake_user_id)
    var eventDetail:[String:String] = [:]
    var eventDetailContacts:[String:String] = [:]
    
    eventDetail["title"] = eventTitleField.text
    eventDetail["date"] = datePickerField.text
    eventDetail["location"] = locationField.text
    eventDetail["message"] = eventContentField.text
    
    itemRef.setValue(eventDetail)
    
    let addContacts = fake_user_id + "/contacts"
    
    if invitedContacts.count != 0{
      for contact in invitedContacts{
        let contactInfo = contact.components(separatedBy: ",")
        eventDetailContacts[contactInfo.first!] = contactInfo.last
      }
    }
    
    ref.child(addContacts).setValue(eventDetailContacts)
    
    print("Inserted data into Firebase Databse")
  }
  
  @IBAction func onPickDateField(_ sender: UITextField) {
    
    let datePickerView: UIDatePicker = UIDatePicker()
    datePickerView.datePickerMode = UIDatePickerMode.date
    sender.inputView = datePickerView
    datePickerView.addTarget(self, action: #selector(CreateEventViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
  }
  
  func datePickerValueChanged(sender:UIDatePicker){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM-dd-yyyy"
    let newDate = dateFormatter.string(from:sender.date)
    datePickerField.text = newDate
    
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

}
