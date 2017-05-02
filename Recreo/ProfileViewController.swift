//
//  ProfileViewController.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvatar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAvatar() {
        avatarImage.layer.cornerRadius = 10.0
        avatarImage.layer.borderWidth = 5.0
        avatarImage.layer.borderColor = UIColor.black.cgColor
        avatarImage.isUserInteractionEnabled = true
    }
    
    @IBAction func onAvatarTap(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController()
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default) { (UIAlertAction) in
            print("take photo")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.camera;
                picker.allowsEditing = false
                self.present(picker, animated: true, completion: nil)
                // Add "save" logic
            }
        }

        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.default) { (UIAlertAction) in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
            // Add "save" logic
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
        }

        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(choosePhotoAction)
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true) {
        }
    }
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        avatarImage.image = newImage
        
        dismiss(animated: true)
    }
}
