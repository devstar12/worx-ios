//
//  EditProfileViewController.swift
//  WORX
//
//  Created by Jaelhorton on 6/4/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire
class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var joinedDateLabel: UILabel!
        
    @IBOutlet weak var playedMatchLabel: UILabel!
    
    @IBOutlet weak var creditLabel: UILabel!

    let photoPicker = UIImagePickerController()
    
    var userInfo: LoginData?
    
    let hud = JGProgressHUD(style: .light)
    
    var imageData: Data?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoPicker.delegate = self
        self.photoPicker.allowsEditing = true
        
        let userProfile = self.userInfo?.user
        let match_count = self.userInfo?.match_count
        // User Info
        let userName = userProfile?.first_name
        let avatar = userProfile?.photo ?? ""
        let joined_date = userProfile?.created_at
        
        var player_avatar = avatar;
        if player_avatar.contains("http") == false {
            player_avatar =  WORXAPI.sharedInstance.getHostURL() + "uploads/photo/" + avatar
        }

        self.profileImageView.sd_setImage(with: URL(string: player_avatar), placeholderImage: UIImage(named: "ic_profile"))
        self.profileImageView.makeRounded()
        self.firstNameTextField.text = userName

        var elapsed_time = WORXHelper.sharedInstance.getElapsedInterval(start_date: Date())
        if joined_date != nil{
            let start_date = WORXHelper.sharedInstance.get24HourDateTimeFromString(timeString: joined_date!)
            elapsed_time = WORXHelper.sharedInstance.getElapsedInterval(start_date: start_date!)
        }
        self.joinedDateLabel.text = elapsed_time
        self.playedMatchLabel.text = "Matches played: " + String(match_count ?? 0)
        // User Credit
        self.creditLabel.text = "Credits £" + (userProfile?.credits ?? "0")
    }
    func setUserInfo(userinfo: LoginData?){
        self.userInfo = userinfo
    }
    @IBAction func onCameraPressed(_ sender: Any) {
        photoActionController()
    }
    
    @IBAction func onSavePressed(_ sender: Any) {
        updateProfile()
    }
    @IBAction func onSettingsPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "settingsViewController") as! SettingsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func photoActionController()
    {
        let alertController = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let cameraTitle = "Take a photo from Camera."
        let libraryTitle = "Pick a photo from Photo Library"
        
        
        let cameraActionButton = UIAlertAction(title: cameraTitle, style: .default) { action -> Void in
            self.photoPicker.allowsEditing = true
            self.photoPicker.sourceType = .camera
            self.photoPicker.cameraCaptureMode = .photo
            self.photoPicker.modalPresentationStyle = .fullScreen
            self.present(self.photoPicker, animated: true, completion: nil)
        }
        
        alertController.addAction(cameraActionButton)
        
        let photoLibraryActionButton = UIAlertAction(title: libraryTitle, style: .default) { action -> Void in
            self.photoPicker.allowsEditing = true
            self.photoPicker.sourceType = .photoLibrary
            self.photoPicker.modalPresentationStyle = .fullScreen
            self.present(self.photoPicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryActionButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageData = UIImage.jpegData(pickedImage)(compressionQuality: 0.8)
            //            self.AddProfileImage(imageData:imgdata!)
            self.profileImageView.image = pickedImage
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateProfile() {
        
        let avatar = UIImage.jpegData(self.profileImageView.image!)(compressionQuality: 0.8)
        if firstNameTextField.text == "" {
            Util.showAlert(vc: self, "WORX", "Enter your name")
            return
        }
        if imageData == nil {
            Util.showAlert(vc: self, "WORX", "Select photo to change")
            return
        }
        let userId = PrefsManager.getUserID()
        let params = [
            "first_name" : firstNameTextField.text!,
            "player_id" : String(userId)
        ]
        print(params)
        
        self.hud.textLabel.text = "Updating"
        self.hud.show(in: self.view, animated: true)
        let url = "\(WORXAPI.sharedInstance.getAPIBaseURL())/player/update"
        
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                multiPart.append(avatar!, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }
        }, to: url)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON { response in
                self.hud.dismiss()
                debugPrint(response)
        }
        
    }
}
