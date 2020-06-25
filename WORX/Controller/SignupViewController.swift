//
//  SignupViewController.swift
//  WORX
//
//  Created by Jaelhorton on 5/18/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit

import JGProgressHUD
import FBSDKLoginKit
class SignupViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    let hud = JGProgressHUD(style: .light)
    
    var fbLoginManager : LoginManager = LoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.dateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
    }
    
    func getUserDetails(){
        if(AccessToken.current != nil){
            DispatchQueue.main.async {
                self.hud.textLabel.text = "Registering..."
                self.hud.show(in: self.view, animated: true)
            }
            GraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email"]).start(completionHandler: { (connection, result, error) in
                guard let Info = result as? [String: Any] else {
                    self.hud.textLabel.text = "Failed to register with facebook"
                    self.hud.dismiss(afterDelay: 2.0, animated: true)
                    return
                }
                print(Info)
                let email = Info["email"] as? String
                let first_name = Info["first_name"] as? String
                let last_name = Info["last_name"] as? String
                let id = Info["id"] as? String
                var picture = "";
                if id != nil {
                    picture = "http://graph.facebook.com/\(id!)/picture?type=large"
                }
                
                AuthManager.sharedInstance.register(email: email!, password: "facebook", firstname: first_name!, lastname: last_name!, birthday: "1980-01-01", photo: picture) { (result, error) in
                    if let result = result{
                        self.hud.textLabel.text = "Registeration successful."
                        self.hud.dismiss(afterDelay: 2.0, animated: true)

                        DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                            self.gotoMainViewController()

                        })
                    }
                    else if let error = error{
                        var message = "Failed to register."
                        switch error {
                        case .existingemail:
                            message = "Existing email."
                        default:
                            message = "Failed to register."
                        }
                        self.hud.textLabel.text = message
                        self.hud.dismiss(afterDelay: 2.0, animated: true)
                    }
                }

            })
        }
    }
    
    @IBAction func onFacebookPressed(_ sender: Any) {
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
    
    @IBAction func onSignUpPressed(_ sender: Any) {
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        let firstname = firstNameTextField.text
        let lastname = lastNameTextField.text
        var birthday = dateTextField.text
        
        birthday = WORXHelper.sharedInstance.getISO8601DateStringFromShortDateString(date: birthday!)
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
        if firstname?.isEmpty == true {
            Util.showNotice("WORX", "Enter your first name")
            return
        }
        
        if birthday?.isEmpty == true {
            Util.showNotice("WORX", "Enter your birthday")
            return
        }
        
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Registering..."
            self.hud.show(in: self.view, animated: true)
        }
        AuthManager.sharedInstance.register(email: email!, password: password!, firstname: firstname!, lastname: lastname!, birthday: birthday!, photo: "") { (result, error) in
            if let result = result{
                self.hud.textLabel.text = "Registeration successful."
                self.hud.dismiss(afterDelay: 2.0, animated: true)

                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.gotoMainViewController()

                })
            }
            else if let error = error{
                var message = "Failed to register."
                switch error {
                case .existingemail:
                    message = "Existing email."
                default:
                    message = "Failed to register."
                }
                self.hud.textLabel.text = message
                self.hud.dismiss(afterDelay: 2.0, animated: true)
            }
        }
    }
    
    func gotoMainViewController() {
        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "mainViewController")
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            self.dateTextField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.dateTextField.resignFirstResponder() // 2-5
    }
}

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
