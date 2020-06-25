//
//  SettingsViewController.swift
//  WORX
//
//  Created by Jaelhorton on 5/19/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onTransactionPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "transactionViewController") as! TransactionViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSignOutPressed(_ sender: Any) {
        PrefsManager.setEmail(val: "")
        PrefsManager.setPassword(val: "")
        
        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "initialViewController")
        UIApplication.shared.windows.first?.rootViewController = vc

    }
    
}
