//
//  DeleteViewController.swift
//  WORX
//
//  Created by Jaelhorton on 6/3/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import JGProgressHUD

class DeleteProfileViewController: UIViewController {

    @IBOutlet weak var firstReasonRadioButton: RadioButton!
    @IBOutlet weak var secondReasonRadioButton: RadioButton!
    @IBOutlet weak var thirdRadioButton: RadioButton!
    @IBOutlet weak var otherRadioButton: RadioButton!
    
    let hud = JGProgressHUD(style: .light)
    
    var selectedReason = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onRadioChanged(_ sender: Any) {
        let radioButton = sender as! RadioButton
        firstReasonRadioButton.radioSelected = (firstReasonRadioButton == radioButton) ? true: false
        secondReasonRadioButton.radioSelected = (secondReasonRadioButton == radioButton) ? true: false
        thirdRadioButton.radioSelected = (thirdRadioButton == radioButton) ? true: false
        otherRadioButton.radioSelected = (otherRadioButton == radioButton) ? true: false

        firstReasonRadioButton.color = UIColor.darkGray
        secondReasonRadioButton.color = UIColor.darkGray
        thirdRadioButton.color = UIColor.darkGray
        otherRadioButton.color = UIColor.darkGray

        firstReasonRadioButton.fillColor = UIColor.darkGray
        secondReasonRadioButton.fillColor = UIColor.darkGray
        thirdRadioButton.fillColor = UIColor.darkGray
        otherRadioButton.fillColor = UIColor.darkGray

        selectedReason = radioButton.title
        if(radioButton == firstReasonRadioButton){
            firstReasonRadioButton.color = UIColor(hexString: "#0088FF")!
            firstReasonRadioButton.fillColor = UIColor(hexString: "#0088FF")!
        }
        else if(radioButton == secondReasonRadioButton){
            secondReasonRadioButton.color = UIColor(hexString: "#0088FF")!
            secondReasonRadioButton.fillColor = UIColor(hexString: "#0088FF")!
        }
        else if(radioButton == thirdRadioButton){
            thirdRadioButton.color = UIColor(hexString: "#0088FF")!
            thirdRadioButton.fillColor = UIColor(hexString: "#0088FF")!
        }
        else if(radioButton == otherRadioButton){
            otherRadioButton.color = UIColor(hexString: "#0088FF")!
            otherRadioButton.fillColor = UIColor(hexString: "#0088FF")!
        }
    }
    func clearSession(){
        PrefsManager.setEmail(val: "")
        PrefsManager.setPassword(val: "")
        PrefsManager.setUserID(val: 0)
        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "initialViewController")
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    func deleteAccount(){
        let userId = PrefsManager.getUserID()
        self.hud.textLabel.text = "Deleting..."
        self.hud.show(in: self.view, animated: true)
        WORXAPI.sharedInstance.deleteAccount(user_id: userId, content: selectedReason){ (response, err) in
            if let response = response {
                self.hud.textLabel.text = "Your account is deleted."
                self.hud.dismiss(afterDelay: 2.0, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.clearSession()
                })
            }
            else if let error = err{
                self.hud.textLabel.text = "Something went wrong. Please try again later."
                self.hud.dismiss(afterDelay: 2.0, animated: true)

            }
        }
    }
    @IBAction func onDeletePressed(_ sender: Any) {
        if selectedReason.isEmpty {
            Util.showAlert(vc: self, "WORX", "Please select the reason.")
            return
        }
        let refreshAlert = UIAlertController(title: "WORX", message: "Are you sure to delete your account?", preferredStyle: .alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteAccount()
        }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSettingsPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "settingsViewController") as! SettingsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
