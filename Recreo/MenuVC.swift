//
//  MenuVC.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/14/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var eventsFeedVC: UIViewController!
    private var profileVC: UIViewController!
    private var archivesVC: UIViewController!
    private var settingsVC: UIViewController!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //eventsFeedVC = storyboard.instantiateViewController(withIdentifier: "EventsFeedNavigationController")
        eventsFeedVC = storyboard.instantiateViewController(withIdentifier: "EventsFeedNavVC")
        profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        archivesVC = storyboard.instantiateViewController(withIdentifier: "ArchivesNavigationController")
        settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationController")
        
        viewControllers.append(eventsFeedVC)
        viewControllers.append(profileVC)
        viewControllers.append(archivesVC)
        viewControllers.append(settingsVC)
        
        hamburgerViewController.contentViewController = eventsFeedVC
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMenuCell", for: indexPath) as! NewMenuCell
        
        let titles = ["Events", "Profile", "Archives", "Settings", "Sign Out"]
        let images = ["menu_events_icon", "menu_user_profile_icon", "menu_archives_icon", "menu_settings_icon", "menu_signout_icon"]
        cell.menuLabel?.text = titles[indexPath.row]
        cell.menuItemImageView.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == 4) {
            let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            print("AVINASH: ID removed from keychain \(keychainResult)")
            try! FIRAuth.auth()?.signOut()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
            
        } else {
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }
    }

}
