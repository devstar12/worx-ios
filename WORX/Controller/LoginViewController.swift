//
//  LoginViewController.swift
//  WORX
//
//  Created by Jaelhorton on 5/18/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit

import JGProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    let hud = JGProgressHUD(style: .light)
    
    var userProfile: UserProfile? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    @IBAction func onLoginPressed(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        if email?.isEmpty == true {
           Util.showNotice("WORX", "Enter your email.")
           return
        }
        if !Util.isValidEmail(emailID: email!) {
            Util.showNotice("WORX", "Enter the valid email.")
            return
        }
        if password!.count < 6 {
           Util.showNotice("WORX", "Password should be 6 in length at least.")
           return
        }
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Logging in..."
            self.hud.show(in: self.view, animated: true)
        }
        AuthManager.sharedInstance.login(email: email!, password: password!) { (result, error) in
            if let result = result{
                self.hud.textLabel.text = "Login successful."
                self.hud.dismiss(afterDelay: 2.0, animated: true)

                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.gotoMainViewController()
                })
            }
            else if let error = error{
                var message = "Failed to login."
                switch error {
                case .invalidCredentials:
                    message = "Invalid email or password."
                default:
                    message = "Failed to login."
                }
                self.hud.textLabel.text = message
                self.hud.dismiss(afterDelay: 2.0, animated: true)
            }
        }
    }
    
    @IBAction func onSignupPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "signupViewController") as! SignupViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotoMainViewController() {
        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "mainViewController")
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}
