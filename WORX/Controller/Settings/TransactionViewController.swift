//
//  TransactionViewController.swift
//  WORX
//
//  Created by Jaelhorton on 6/3/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import JGProgressHUD

class TransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var transactionTableView: UITableView!
    
    let hud = JGProgressHUD(style: .light)
    var transactionList: [TransactionData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        getTransactionHistory()
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func getTransactionHistory(){
        let userId = PrefsManager.getUserID()
        
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view, animated: true)
        WORXAPI.sharedInstance.transactionHistory(user_id: userId){ (response, err) in
            if let response = response {
                self.transactionList = response.data
                self.transactionTableView.reloadData()
            }
            self.hud.dismiss()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionCell
        let transactionData = self.transactionList[indexPath.row]
        cell.dateLabel.text = WORXHelper.sharedInstance.getRFCDateTimeFromString(timeString: transactionData.created_at)
        cell.transactionLabel.text = transactionData.event_name
        cell.amountLabel.text = "£" + transactionData.amount

        let amount = Int(transactionData.amount) ?? 0
        if amount > 0 {
            cell.amountLabel.textColor = UIColor(hexString: "#2FDD0F")
        }
        else{
            cell.amountLabel.textColor = UIColor.red
        }
        
        return cell
    }
}
