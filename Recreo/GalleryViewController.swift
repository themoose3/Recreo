//
//  GalleryViewController.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase

class GalleryViewController: UIViewController {
//class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

//    @IBOutlet weak var collectView: UICollectionView!
//    
//    let photosArray: [UIImage] = [#imageLiteral(resourceName: "event1_bg"), #imageLiteral(resourceName: "clem-onojeghuo-151794")]
//  
//    var ref: FIRDatabaseReference!
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectView.delegate = self
//        collectView.dataSource = self
//      
//        //get current event unique key is required.
//        let eventId = "KjgMNlNHwS3bNerzSeH";
//      
//        ref = FIRDatabase.database().reference()
//      
//      ref.child("Events").child(eventId).observeSingleEvent(of: .value, with: { (snapshot) in
//        
//          let value = snapshot.value as? NSDictionary
//          let imageUrl = value?["imagrUrl"] as? String ?? "no image"
//          print(imageUrl)
//      })
    }

//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
//        //cell.photo.image = photosArray[indexPath.row]
//
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
    @IBAction func onCancelButton(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func onUploadButton(_ sender: Any) {
      print("upload image")
    }
  
}
