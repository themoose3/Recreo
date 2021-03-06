//
//  ProfileViewController.swift
//  Recreo
//
//  Created by Angie Lal on 4/30/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Firebase

//enum TextField {
//    case name
//    case email
//}

//class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
class ProfileViewController: UIViewController {

//    
//    @IBOutlet weak var phoneNumberTextField: UITextField!
//    @IBOutlet weak var avatarImage: UIImageView!
//    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    let defaults = UserDefaults.standard
//    let userRef = FIRDatabase.database().reference().child("users")
//    
//    var activeField: UITextField?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupFields()
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//
//        nameTextField.delegate = self
//        emailTextField.delegate = self
//        
//        registerForKeyboardNotifications()
//        // Do any additional setup after loading the view.
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setupFields() {
//        if let name = defaults.string(forKey: "UserName") {
//            nameTextField.text = name
//        } else {
//            nameTextField.text = ""
//        }
//        phoneNumberTextField.text = "+14081234567"
//        //let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        //let image = UIImage(named: "cellphone.png")
//        //imageView.image = image
//        //phoneNumberTextField.leftView = imageView
//        //phoneNumberTextField.leftViewMode = UITextFieldViewMode.always
//
//        emailTextField.text = defaults.string(forKey: "UserEmail")
//        setupEmail()
//
//        setupAvatar()
//
//    }
//    
//    func setupEmail() {
//        //let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        //let image = UIImage(named: "email.png")
//        //imageView.image = image
//        //emailTextField.leftView = imageView
//        //emailTextField.leftViewMode = UITextFieldViewMode.always
//    }
//    
//    func setupAvatar() {
//        avatarImage.layer.cornerRadius = 10.0
//        avatarImage.layer.borderWidth = 5.0
//        avatarImage.layer.borderColor = UIColor.black.cgColor
//        avatarImage.isUserInteractionEnabled = true
//        
//        if let avatar = defaults.data(forKey: "UserProfileImage") {
//            avatarImage.image = UIImage(data: avatar)
//        }
//    }
//    
//    @IBAction func onAvatarTap(_ sender: UITapGestureRecognizer) {
//        let actionSheet = UIAlertController()
//        let takePhotoAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default) { (UIAlertAction) in
//            print("take photo")
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                let picker = UIImagePickerController()
//                picker.delegate = self
//                picker.sourceType = UIImagePickerControllerSourceType.camera;
//                picker.allowsEditing = false
//                self.present(picker, animated: true, completion: nil)
//                // Add "save" logic
//            }
//        }
//
//        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.default) { (UIAlertAction) in
//            let picker = UIImagePickerController()
//            picker.allowsEditing = true
//            picker.delegate = self
//            self.present(picker, animated: true)
//            // Add "save" logic
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
//        }
//
//        actionSheet.addAction(takePhotoAction)
//        actionSheet.addAction(choosePhotoAction)
//        actionSheet.addAction(cancelAction)
//
//        self.present(actionSheet, animated: true) {
//        }
//    }
//    /*
//     // MARK: - Navigation
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        var newImage: UIImage
//        
//        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            newImage = possibleImage
//        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            newImage = possibleImage
//        } else {
//            return
//        }
//        
//        // do something interesting here!
//        avatarImage.image = newImage
//        saveImage()
//        
//        dismiss(animated: true)
//    }
//    
//    func saveImage(){
//        let imageData = UIImagePNGRepresentation(avatarImage.image!)
//        defaults.set(imageData, forKey: "UserProfileImage")
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField){
//        activeField = textField
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("got here")
//        if textField == nameTextField {
//            saveText(textField: .name)
//            print("edited name")
//        } else {
//            saveText(textField: .email)
//            print("edited email")
//        }
//         textField.resignFirstResponder()
//        activeField = nil
//    }
//    
//    func saveText(textField: TextField) {
//        let userId = defaults.string(forKey: "User")
//        let specificUserRef = userRef.child(userId!)
//        
//        switch textField {
//        case .name:
//            specificUserRef.child("name").setValue(nameTextField.text)
//            defaults.set(nameTextField.text, forKey: "UserName")
//            print("name")
//        default:
//            specificUserRef.child("email").setValue(emailTextField.text)
//            defaults.set(emailTextField.text, forKey: "UserEmail")
//            print("email")
//        }
//    }
//    
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print("TextField should return method called")
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    func registerForKeyboardNotifications(){
//        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    func deregisterFromKeyboardNotifications(){
//        //Removing notifies on keyboard appearing
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    func keyboardWasShown(notification: NSNotification){
//        //Need to calculate keyboard exact size due to Apple suggestions
//        self.scrollView.isScrollEnabled = true
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//        
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//        
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if let activeField = self.activeField {
//            if (!aRect.contains(activeField.frame.origin)){
//                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
//            }
//        }
//    }
//    
//    func keyboardWillBeHidden(notification: NSNotification){
//        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//        self.view.endEditing(true)
//        self.scrollView.isScrollEnabled = false
//    }
//    
//    @IBAction func onCreateEventTest(_ sender: Any) {
//      print("button clicked")
//      performSegue(withIdentifier: "createEventSegue", sender: nil)
//    }
    
}
