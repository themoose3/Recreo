//
//  NewMenuCell.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/14/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit

class NewMenuCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuItemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}