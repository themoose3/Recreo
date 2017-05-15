//
//  GalleryViewController.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectView: UICollectionView!
    
    var photosArray: [UIImage] = []
    var photosUrlArray: [String] = []
  
    var ref: FIRDatabaseReference!
    var pickedImage: UIImage!
    //var selectedEventId: String!
  
    var selectedEventId: String!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        collectView.delegate = self
        collectView.dataSource = self
      
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //get current event unique key is required.
        //let eventId = self.selectedEventId!
        let eventId = selectedEventId!
      
        ref = FIRDatabase.database().reference()
        ref.child("Events").child(eventId).observe(FIRDataEventType.value, with: { (snapshot) in
          let dataDict = snapshot.value as! NSDictionary
          if let imageUrlString = dataDict["galleryImageUrls"] as? [String]{
            for image in imageUrlString{
              let imageUrl = URL(string:image)
              let imageData = try? Data(contentsOf: imageUrl!)
              self.photosUrlArray.append(image)
              self.photosArray.append(UIImage(data:imageData!)!)
            }
          }
          MBProgressHUD.hide(for: self.view, animated: true)
          self.collectView.reloadData()
          
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photo.image = photosArray[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
  
    @IBAction func onCancelButton(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func onUploadButton(_ sender: Any) {
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      
      let actionSheet = UIAlertController(title: "Upload photos", message: "Choose a source", preferredStyle: .actionSheet)
      
      actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
          imagePickerController.sourceType = .camera
          self.present(imagePickerController, animated:true, completion: nil)
        }else{
          print("Camera not available")
        }
        
      }))
      
      actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated:true, completion: nil)
      }))
      
      actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
      
      self.present(actionSheet, animated:true, completion: nil)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
      if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.pickedImage = image
        self.photosArray.append(self.pickedImage)
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("event_images").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.pickedImage!){
          storageRef.put(uploadData, metadata:nil, completion:{(metadata, error) in
            
            if error != nil{
              print(error)
              return
            }
            
            if let eventImageUrl = metadata?.downloadURL()?.absoluteString{
              let firebaseDatabaseReference = FIRDatabase.database().reference()
              let eventReference = firebaseDatabaseReference.child("Events").child(self.selectedEventId).child("galleryImageUrls")
              
              self.photosUrlArray.append(eventImageUrl)
              
              eventReference.setValue(self.photosUrlArray)
              
              print("insertion is completed")
            }
            
          })
        }
        
        MBProgressHUD.hide(for: self.view, animated: true)
        self.collectView.reloadData()
        
      }else{
        print("wrong")
      }
    
      picker.dismiss(animated: true, completion: nil)
    }
  
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      self.dismiss(animated: true, completion: nil)
    }
  
}
