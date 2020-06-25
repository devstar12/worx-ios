//
//  BookPlaceViewController.swift
//  WORX
//
//  Created by Jaelhorton on 6/5/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD
import FormTextField
class BookPlaceViewController: UIViewController {
    var delegate: RefreshDataDelegateProtocol? = nil
    
    var match: MatchData?
    
    let hud = JGProgressHUD(style: .light)
    
    @IBOutlet weak var hostAvatarImageView: UIImageView!
    @IBOutlet weak var matchTitleLabel: UILabel!
    @IBOutlet weak var matchLocationLabel: UILabel!
    @IBOutlet weak var matchSizeLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var matchCostLabel: UILabel!
    @IBOutlet weak var matchRuleLabel: UILabel!
    @IBOutlet weak var matchTimeLabel: UILabel!
    
    @IBOutlet weak var cardNumberTextField: FormTextField!
    @IBOutlet weak var expiryDateTextField: FormTextField!
    @IBOutlet weak var cvcTextField: FormTextField!
    
    @IBOutlet weak var amountTextField: FormTextField!

    @IBOutlet weak var userCreditLabel: UILabel!
    
    @IBOutlet weak var creditCardView: UIView!
    
    @IBOutlet weak var attendeeCollectionView: UICollectionView!
    private let heightHeader = 80
    
    @IBOutlet weak var bookPlaceButton: UIButton!
    
    var playerList: [PlayerData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Card Number
        cardNumberTextField.inputType = .integer
        cardNumberTextField.formatter = CardNumberFormatter()
        var validation = Validation()
        validation.minimumLength = "1234 5678 1234 5678".count
        validation.maximumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator1 = InputValidator(validation: validation)
        cardNumberTextField.inputValidator = inputValidator1
        // Expiry Date
        expiryDateTextField.formatter = CardExpirationDateFormatter()
        expiryDateTextField.inputType = .integer
        validation.minimumLength = 1
        let inputValidator2 = CardExpirationDateInputValidator(validation: validation)
        expiryDateTextField.inputValidator = inputValidator2
        // Security Code
        cvcTextField.inputType = .integer
        validation.maximumLength = "CVC".count
        validation.minimumLength = "CVC".count
        validation.characterSet = CharacterSet.decimalDigits
        let inputValidator3 = InputValidator(validation: validation)
        cvcTextField.inputValidator = inputValidator3
        // Amount
        amountTextField.inputType = .integer
        validation.minimumLength = 1
        validation.characterSet = CharacterSet.decimalDigits
        let inputValidator4 = InputValidator(validation: validation)
        amountTextField.inputValidator = inputValidator4

        self.loadMatchData()
    }
    func loadMatchData(){
        if match == nil{
            return
        }
        creditCardView.isHidden = true
        matchTitleLabel.text = match?.title
        matchLocationLabel.text = match?.address
        matchSizeLabel.text = WORXHelper.sharedInstance.getMatchSize(with: Int(match?.max_players ?? "0"))
        hostNameLabel.text = match?.host_name
        let host_avatar =  WORXAPI.sharedInstance.getHostURL() + "uploads/host/" + match!.host_photo

        hostAvatarImageView.sd_setImage(with: URL(string: host_avatar), placeholderImage: UIImage(named: "ic_profile"))
        matchRuleLabel.text = match?.rules
        matchCostLabel.text = "£" + match!.credits
        matchTimeLabel.text = WORXHelper.sharedInstance.get12HourTimeStringFromFullTimeDate(timeString: match!.start_time)

        self.playerList = match!.players ?? [PlayerData]()
        
        attendeeCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        dateCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        attendeeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        attendeeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        attendeeCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(heightHeader)).isActive = true
        (attendeeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        attendeeCollectionView.showsHorizontalScrollIndicator = false
        attendeeCollectionView.delegate = self
        attendeeCollectionView.dataSource = self
        attendeeCollectionView.reloadData()
        
        getPlayerInfo()
    }
    func getPlayerInfo(){
        let userId = PrefsManager.getUserID()
        var isBooked = false
        for player in playerList {
            if player.id == userId{
                isBooked = true
                break
            }
        }
        if isBooked == true {
            bookPlaceButton.isEnabled = false
            bookPlaceButton.backgroundColor = UIColor.gray
        }
        else{
            bookPlaceButton.isEnabled = true
            bookPlaceButton.backgroundColor = UIColor(hexString: "#0088FF")
        }
        
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view, animated: true)
        WORXAPI.sharedInstance.getPlayerInfo(user_id: userId){ (response, err) in
            if let response = response {
                let userProfile = response.data.user
                // User Credit
                self.userCreditLabel.text = "£" + (userProfile.credits ?? "0")
                // Check Balance
                let userCredit = Int(userProfile.credits ?? "0") ?? 0
                let matchCost = Int(self.match?.credits ?? "0") ?? 0
                if matchCost > userCredit {
                    self.creditCardView.isHidden = false
                }
                else{
                    self.creditCardView.isHidden = true
                }
            }
            self.hud.dismiss()
        }
    }
    func setMatch(match: MatchData){
        self.match = match
    }

    @IBAction func onBookPlacePressed(_ sender: Any) {
        self.hud.textLabel.text = "Booking"
        self.hud.show(in: self.view, animated: true)
        let userId = PrefsManager.getUserID()
        let matchId = match?.id
        WORXAPI.sharedInstance.bookPlace(user_id: userId, match_id: matchId!){ (response, err) in
            if let response = response {
                self.hud.textLabel.text = "Success"
                self.hud.dismiss(afterDelay: 2.0, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
//                    self.getPlayerInfo()
                    self.delegate?.refreshViewController()
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else{
                self.hud.textLabel.text = "Failed to book place"
                self.hud.dismiss(afterDelay: 2.0, animated: true)
            }
        }
    }
    
    @IBAction func onProcessPressed(_ sender: Any) {
        if cardNumberTextField.validate() == false{
            return
        }
        if expiryDateTextField.validate() == false {
            return
        }
        if cvcTextField.validate() == false {
            return
        }
        if amountTextField.validate() == false {
            return
        }
        var message = "Please confirm your payment information"
        message += "\n"
        message += "Card Number: " + cardNumberTextField.text!
        message += "\n"
        message += "Expiry Date: " + expiryDateTextField.text!
        message += "\n"
        message += "CVC: " + cvcTextField.text!
        message += "\n"
        message += "Amount: £" + amountTextField.text!
        let refreshAlert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .actionSheet)

        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.processPayment()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)

    }
    func processPayment(){
        self.hud.textLabel.text = "Processing"
        self.hud.show(in: self.view, animated: true)
        let userId = PrefsManager.getUserID()
        let cardNumber = cardNumberTextField.text
        let expiryDate = expiryDateTextField.text
        // Date Format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let date = dateFormatter.date(from: expiryDate!)
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date!)
        let year = calendar.component(.year, from: date!)
        // CVC
        let cardCVC = cvcTextField.text
        let amount = amountTextField.text
        WORXAPI.sharedInstance.purchasePayment(user_id: userId, cardNumber: cardNumber!, expiryMonth: month, expiryYear: year, cardCVC: cardCVC!, amount: amount!){ (response, err) in
            if let response = response {
                self.hud.textLabel.text = "Success"
                DispatchQueue.main.asyncAfter(deadline: .now()+1.1, execute: {
                    self.getPlayerInfo()
                })
            }
            else{
                self.hud.textLabel.text = "Failed to purchase credits"
                self.hud.dismiss(afterDelay: 2.0, animated: true)
            }
        }
    }
    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension BookPlaceViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerData = playerList[indexPath.row]
        let vc =  self.storyboard?.instantiateViewController(identifier: "otherProfileViewController") as! OtherProfileViewController
        vc.setPlayerInfo(playerInfo: playerData)
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

extension BookPlaceViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attendeeCell", for: indexPath) as! AttendeeCell
        let playerData = playerList[indexPath.row]
        
        var player_avatar = playerData.photo;
        if player_avatar.contains("http") == false {
            player_avatar =  WORXAPI.sharedInstance.getHostURL() + "uploads/photo/" + playerData.photo
        }

        cell.playerAvatar.sd_setImage(with: URL(string: player_avatar), placeholderImage: UIImage(named: "ic_profile"))
        cell.playerAvatar.makeRounded()
        cell.playerName.text = playerData.first_name
        
        return cell
    }
}

extension BookPlaceViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacer = CGFloat(playerList.count)
        return CGSize(width: view.frame.width / spacer, height: CGFloat(heightHeader))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
