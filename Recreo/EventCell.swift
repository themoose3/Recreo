//
//  EventCell.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/6/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    
    var event: Event! {
        didSet {
            eventLabel.text = event.eventName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
