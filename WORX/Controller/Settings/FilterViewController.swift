//
//  FilterViewController.swift
//  WORX
//
//  Created by Jaelhorton on 6/3/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    var delegate: RefreshDataDelegateProtocol? = nil

    
    @IBOutlet weak var size5vs5Button: RoundButton!
    @IBOutlet weak var size6vs6Button: RoundButton!
    @IBOutlet weak var size7vs7Button: RoundButton!
    @IBOutlet weak var size8vs8Button: RoundButton!
    @IBOutlet weak var size9vs9Button: RoundButton!
    @IBOutlet weak var size10vs10Button: RoundButton!
    @IBOutlet weak var size11vs11Button: RoundButton!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var priceSlider: UISlider!
    
    var matchSizeList: [Int] = []
    var matchCost: Int = 0
    var matchDistance: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        
        matchCost = PrefsManager.getMatchCost()
        matchDistance = PrefsManager.getMatchDistance()
        matchSizeList = PrefsManager.getMatchSizeList()
        
        distanceSlider.setValue(Float(matchDistance), animated: false)
        priceSlider.setValue(Float(matchCost), animated: false)
                
        if(matchSizeList.count != 0) {
            size5vs5Button.isSelected = false
            size6vs6Button.isSelected = false
            size7vs7Button.isSelected = false
            size8vs8Button.isSelected = false
            size9vs9Button.isSelected = false
            size10vs10Button.isSelected = false
            size11vs11Button.isSelected = false
            for item in matchSizeList {
                if item == 10{
                    size5vs5Button.isSelected = true
                }
                else if item == 12 {
                    size6vs6Button.isSelected = true
                }
                else if item == 14 {
                    size7vs7Button.isSelected = true
                }
                else if item == 16 {
                    size8vs8Button.isSelected = true
                }
                else if item == 18 {
                    size9vs9Button.isSelected = true
                }
                else if item == 20 {
                    size10vs10Button.isSelected = true
                }
                else if item == 22 {
                    size11vs11Button.isSelected = true
                }
            }
        }
        else{
            size5vs5Button.isSelected = true
            size6vs6Button.isSelected = true
            size7vs7Button.isSelected = true
            size8vs8Button.isSelected = true
            size9vs9Button.isSelected = true
            size10vs10Button.isSelected = true
            size11vs11Button.isSelected = true
        }
        refreshButtons()
        onDistanceChanged(nil)
        onPriceChanged(nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDistanceChanged(_ sender: Any?) {
        let step: Float = 1
        distanceSlider.value = round((distanceSlider.value)/step)*step
        matchDistance = Int(distanceSlider.value)
        distanceLabel.text = "Distance: " + String( matchDistance) + "km"
    }
    
    @IBAction func onPriceChanged(_ sender: Any?) {
        let step: Float = 1
        priceSlider.value = round((priceSlider.value)/step)
        matchCost = Int(priceSlider.value)
        priceLabel.text = "Price: £" + String( matchCost)

    }
    
    func refreshButtons() {
        matchSizeList.removeAll()
        if size5vs5Button.isSelected {
            matchSizeList.append(10)
            size5vs5Button.backgroundColor = UIColor(hexString: "#0088FF")
        }
        else{
            size5vs5Button.backgroundColor = UIColor.gray
        }
        if size6vs6Button.isSelected {
            matchSizeList.append(12)
            size6vs6Button.backgroundColor = UIColor(hexString: "#0088FF")
        }
        else{
            size6vs6Button.backgroundColor = UIColor.gray
        }
        if size7vs7Button.isSelected {
            matchSizeList.append(14)
            size7vs7Button.backgroundColor = UIColor(hexString: "#0088FF")
        }
        else{
            size7vs7Button.backgroundColor = UIColor.gray
        }
        if size8vs8Button.isSelected {
            matchSizeList.append(16)
            size8vs8Button.backgroundColor = UIColor(hexString: "#0088FF")
        }
        else{
            size8vs8Button.backgroundColor = UIColor.gray
        }
        if size9vs9Button.isSelected {
            matchSizeList.append(18)
            size9vs9Button.backgroundColor = UIColor(hexString: "#0088FF")
        }
        else{
            size9vs9Button.backgroundColor = UIColor.gray
        }
        if size10vs10Button.isSelected {
            matchSizeList.append(20)
            size10vs10Button.backgroundColor = UIColor(hexString: "#0088FF")
        }
        else{
            size10vs10Button.backgroundColor = UIColor.gray
        }
        if size11vs11Button.isSelected {
            matchSizeList.append(22)
            size11vs11Button.backgroundColor = UIColor(hexString: "#0088FF")
        }
        else{
            size11vs11Button.backgroundColor = UIColor.gray
        }

    }
    @IBAction func onSizePressed(_ sender: Any) {
        let button = sender as! UIButton
        if button.isSelected == false{
            button.isSelected = true
            button.backgroundColor = UIColor(hexString: "#0088FF")
        }
        else{
            button.isSelected = false
            button.backgroundColor = UIColor.gray
        }
    }
    
    @IBAction func onSavePressed(_ sender: Any) {
        PrefsManager.setMatchDistance(val: matchDistance as Int)
        PrefsManager.setMatchCost(val: matchCost as Int)
        refreshButtons()
        PrefsManager.setMatchSizeList(matchList: matchSizeList)
        self.delegate?.refreshViewController()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
