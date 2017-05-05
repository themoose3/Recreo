//
//  MenuViewController.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/4/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var eventsFeedViewController: UIViewController!
    private var profileNavigationController: UIViewController!
    private var archivesViewController: UIViewController!
    private var settingsViewController: UIViewController!
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        eventsFeedViewController = storyboard.instantiateViewController(withIdentifier: "EventsFeedNavigationController")
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        
        viewControllers.append(eventsFeedViewController)
        viewControllers.append(profileNavigationController)
        

        //hamburgerViewController.contentViewController = profileNavigationController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height/4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Events"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Profile"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Archives"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "Settings"
        } else {
            cell.textLabel?.text = "Sign Out"
        }
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 21)
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
