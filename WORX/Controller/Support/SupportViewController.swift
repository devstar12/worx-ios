//
//  SupportViewController.swift
//  WORX
//
//  Created by Jaelhorton on 5/18/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onReportPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "reportViewController") as! ReportViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onFeedbackPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "feedbackViewController") as! FeedbackViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func onDeleteProfilePressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "deleteProfileViewController") as! DeleteProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func onSettingsPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "settingsViewController") as! SettingsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
