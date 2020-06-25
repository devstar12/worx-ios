//
//  SplashViewController.swift
//  WORX
//
//  Created by Jaelhorton on 5/18/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import JGProgressHUD
import FBSDKLoginKit

class SplashViewController: UIViewController {

    let hud = JGProgressHUD(style: .light)
    var fbLoginManager : LoginManager = LoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        if(PrefsManager.getEmail() != ""){
            let email = PrefsManager.getEmail()
            let password = PrefsManager.getPassword()
            DispatchQueue.main.async {
                self.hud.textLabel.text = "Loading..."
                self.hud.show(in: self.view, animated: true)
            }
            AuthManager.sharedInstance.login(email: email, password: password) { (result, error) in
                self.hud.dismiss()
                if let result = result{
                    let vc = mainstoryboard.instantiateViewController(withIdentifier: "mainViewController")
                    UIApplication.shared.windows.first?.rootViewController = vc
                }
                else{
//                    let vc = mainstoryboard.instantiateViewController(withIdentifier: "mainViewController")
//                    UIApplication.shared.windows.first?.rootViewController = vc
                }
            }
        }
        
    }
    


    @IBAction func onLoginWithEmailPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "loginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onJoinPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "signupViewController") as! SignupViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getUserDetails(){
        if(AccessToken.current != nil){
            DispatchQueue.main.async {
                self.hud.textLabel.text = "Logging in..."
                self.hud.show(in: self.view, animated: true)
            }
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name , first_name, last_name , email"]).start(completionHandler: { (connection, result, error) in
                guard let Info = result as? [String: Any] else {
                    self.hud.textLabel.text = "Failed to login with facebook"
                    self.hud.dismiss(afterDelay: 2.0, animated: true)
                    return
                }
                let email = Info["email"] as? String
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                AuthManager.sharedInstance.login(email: email ?? "", password: "facebook") { (result, error) in
                    if let result = result{
                        self.hud.dismiss()
                        let vc = mainstoryboard.instantiateViewController(withIdentifier: "mainViewController")
                        UIApplication.shared.windows.first?.rootViewController = vc
                    }
                    else{
                        self.hud.textLabel.text = "Failed to login with facebook"
                        self.hud.dismiss(afterDelay: 2.0, animated: true)
                    }
                }

            })
        }
    }
    @IBAction func onLoginWithFacebookPressed(_ sender: Any) {
        fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email","public_profile"], from: self) { result, error in
            if error != nil
            {
                
            }
            else if(result?.isCancelled)!
            {
                print("dfdfsdf")
            }
            else
            {
                self.getUserDetails()
            }
        }
    }
}
