//
//  CreateEventViewController.swift
//  Recreo
//
//  Created by sideok you on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var eventTitleField: UITextField!
  @IBOutlet weak var datePickerField: UITextField!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var eventContentField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //we should return count of returned dictionary from ContactListController
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // we do not need to do anything in here because the goal is to show invited contact list from user
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell") as! ContactListCell
    
    return cell
    
  }
  @IBAction func onCreateButton(_ sender: Any) {
    
    //needs to store all input values to firebase database
  }
  @IBAction func onInviteFriendButton(_ sender: Any) {
    //needs to call ContactListController
  }

}
