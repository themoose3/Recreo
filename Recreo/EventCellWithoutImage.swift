//
//  EventCellWithoutImage.swift
//  Recreo
//
//  Created by Padmanabhan, Avinash on 5/6/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import AFNetworking

class EventCellWithoutImage: UITableViewCell {

    @IBOutlet weak var eventCellMessageLabel: UILabel!
    @IBOutlet weak var eventHostProfileImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventMonthLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDayTimeLocationLabel: UILabel!
    
    var event: Event! {
        didSet {
            eventCellMessageLabel.text = "\(event.eventHost.firstName) is hosting an event"
            
            let eventDate = event.eventDate
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMM"
            let monthString = dateFormatter.string(from: eventDate)
            eventMonthLabel.text = monthString.uppercased()

            dateFormatter.dateFormat = "dd"
            let dateString = dateFormatter.string(from: eventDate)
            eventDateLabel.text = dateString.uppercased()
            
            eventNameLabel.text = event.eventName
            
            dateFormatter.dateFormat = "E"
            let dayOfWeekString = dateFormatter.string(from: eventDate)
            dateFormatter.dateFormat = "h:mm a"
            let timeString = dateFormatter.string(from: eventDate)
            eventDayTimeLocationLabel.text = "\(dayOfWeekString) \(timeString) at \(event.eventVenue), \(event.eventCity) \(event.eventState)"
            
            
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
