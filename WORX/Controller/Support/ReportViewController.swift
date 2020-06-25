//
//  ReportViewController.swift
//  WORX
//
//  Created by Jaelhorton on 6/3/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import JGProgressHUD

class ReportViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var reportTextView: UITextView!
    
    let hud = JGProgressHUD(style: .light)
    
    let placeholderText = "Please report any problem here"
    override func viewDidLoad() {
        super.viewDidLoad()

        reportTextView.delegate = self
        reportTextView.text = placeholderText
        reportTextView.textColor = UIColor.lightGray
    }
    
    
    @IBAction func onSendPressed(_ sender: Any) {
        let content = reportTextView.text
        if content == placeholderText{
            Util.showAlert(vc: self, "WORX", "Please enter text to report.")
            return;
        }
        let userId = PrefsManager.getUserID()
        self.hud.textLabel.text = "Sending..."
        self.hud.show(in: self.view, animated: true)
        WORXAPI.sharedInstance.sendFeedback(user_id: userId, type: 1, content: content!){ (response, err) in
            if let response = response {
                self.hud.textLabel.text = "Report provided."
                self.hud.dismiss(afterDelay: 2.0, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else if let error = err{
                self.hud.textLabel.text = "Something went wrong. Please try again later."
                self.hud.dismiss(afterDelay: 2.0, animated: true)

            }
        }
    }
    

    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSettingsPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "settingsViewController") as! SettingsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
}
