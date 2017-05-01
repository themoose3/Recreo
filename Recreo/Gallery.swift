//
//  Gallery.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation


class Gallery: NSObject {
    
    var galleryId: Int
    var eventId: Int
    var photos: [Photo]?
    
    init(galleryId: Int, eventId: Int) {
        self.galleryId = galleryId
        self.eventId = eventId
    }
    
    
    
}
