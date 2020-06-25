//
//  ProfileViewController.swift
//  WORX
//
//  Created by Jaelhorton on 5/18/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import JGProgressHUD

class ProfileViewController: UIViewController {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var joinedDateLabel: UILabel!
    
    @IBOutlet weak var playedMatchLabel: UILabel!
    
    @IBOutlet weak var creditLabel: UILabel!
    
    let hud = JGProgressHUD(style: .light)
    
    var userInfo: LoginData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = PrefsManager.getFirstName()
        let avatar = PrefsManager.getAvatar()
        
        let player_avatar =  WORXAPI.sharedInstance.getHostURL() + "uploads/photo/" + avatar
        userAvatarImageView.sd_setImage(with: URL(string: player_avatar), placeholderImage: UIImage(named: "ic_profile"))
        userAvatarImageView.makeRounded()
        userNameLabel.text = userName
    }
    override func viewDidAppear(_ animated: Bool) {
        // Get Player Info
        getPlayerInfo()

    }
    
    func getPlayerInfo(){
        let userId = PrefsManager.getUserID()
        
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view, animated: true)
        WORXAPI.sharedInstance.getPlayerInfo(user_id: userId){ (response, err) in
            if let response = response {
                self.userInfo = response.data
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
                self.userAvatarImageView.sd_setImage(with: URL(string: player_avatar), placeholderImage: UIImage(named: "ic_profile"))
                self.userAvatarImageView.makeRounded()
                self.userNameLabel.text = userName

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
            self.hud.dismiss()
        }
    }
    
    @IBAction func onEditProfilePressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "editProfileViewController") as! EditProfileViewController
        vc.setUserInfo(userinfo: userInfo)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSettingsPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "settingsViewController") as! SettingsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
