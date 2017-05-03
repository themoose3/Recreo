//
//  ContactListCell.swift
//  Recreo
//
//  Created by sideok you on 5/3/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit

class ContactListCell: UITableViewCell {
    @IBOutlet weak var invitedUserLabel: UILabel!
    @IBOutlet weak var invitedUserPhoneNumberLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
