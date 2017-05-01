//
//  Photo.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import Foundation


class Photo: NSObject {
    
    var photoId: Int
    var galleryId: Int
    var caption: String?
    
    init(photoId: Int, galleryId: Int) {
        self.photoId = photoId
        self.galleryId = galleryId
    }
}
