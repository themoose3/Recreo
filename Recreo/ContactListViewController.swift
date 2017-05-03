//
//  ContactListViewController.swift
//  Recreo
//
//  Created by sideok you on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import ContactsUI

class ContactListViewController: UIViewController, CNContactPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
      
      //Load all contacts when view did load
      let cnPicker = CNContactPickerViewController()
      cnPicker.delegate = self
      self.present(cnPicker, animated: true, completion: nil)
    }
  
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
      contacts.forEach{
        contact in
          for number in contact.phoneNumbers{
            let phoneNumber = number.value
            print("number is = \(phoneNumber)")
          }
      }
      
      //need to store the contact(s) that user picked. dic will be okay, and it has to be sent to CreateEventViewController
    }
  
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      print("Cancel Contact Picker")
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

}
