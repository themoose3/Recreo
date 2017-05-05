//
//  ArchivesViewController.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/5/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit

class ArchivesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("EventCell", owner: self, options: nil)?.first as! EventCell
        cell.label1.text = "row \(indexPath.row)"
        cell.label2.text = "string \(indexPath.row)"
        
        return cell
    }


}
