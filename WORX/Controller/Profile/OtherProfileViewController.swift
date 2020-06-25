//
//  OtherProfileViewController.swift
//  WORX
//
//  Created by Jaelhorton on 6/6/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import JGProgressHUD
class OtherProfileViewController: UIViewController {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var joinedDateLabel: UILabel!
    
    @IBOutlet weak var playedMatchLabel: UILabel!
    
    
    let hud = JGProgressHUD(style: .light)
    
    var playerInfo: PlayerData?
    var userInfo: LoginData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = playerInfo?.first_name
        let avatar = playerInfo?.photo ?? ""
        
        var player_avatar = avatar;
        if player_avatar.contains("http") == false {
            player_avatar =  WORXAPI.sharedInstance.getHostURL() + "uploads/photo/" + avatar
        }

        self.userAvatarImageView.sd_setImage(with: URL(string: player_avatar), placeholderImage: UIImage(named: "ic_profile"))
        self.userAvatarImageView.makeRounded()
        self.userNameLabel.text = userName

        let joined_date = playerInfo?.created_at
        var elapsed_time = WORXHelper.sharedInstance.getElapsedInterval(start_date: Date())
        if joined_date != nil{
            let start_date = WORXHelper.sharedInstance.get24HourDateTimeFromString(timeString: joined_date!)
            elapsed_time = WORXHelper.sharedInstance.getElapsedInterval(start_date: start_date!)
        }
        self.joinedDateLabel.text = elapsed_time

        getPlayerInfo()
    }
    func getPlayerInfo(){
        let userId = playerInfo?.id ?? 0
        
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
                
                let player_avatar =  WORXAPI.sharedInstance.getHostURL() + "uploads/photo/" + avatar
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
            }
            self.hud.dismiss()
        }
    }
    func setPlayerInfo(playerInfo: PlayerData?){
        self.playerInfo = playerInfo
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
