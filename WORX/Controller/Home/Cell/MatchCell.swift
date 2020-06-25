//
//  MatchCell.swift
//  WORX
//
//  Created by Jaelhorton on 5/23/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {
    
    @IBOutlet weak var hostProfileImageView: UIImageView!
    
    @IBOutlet weak var hostNameLabel: UILabel!
    
    @IBOutlet weak var matchTitleLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var matcHSizeLabel: UILabel!
    
    @IBOutlet weak var matchCostLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var bookPlaceButton: RoundButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var playerCountLabel: UILabel!
    
    
    
    var index: Int!
    var callbackBook: ((_ index: Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.backgroundColor = .white

        containerView.layer.cornerRadius = 10.0

        containerView.layer.shadowColor = UIColor.gray.cgColor

        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        containerView.layer.shadowRadius = 5.0

        containerView.layer.shadowOpacity = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onBookPlacePressed(_ sender: Any) {
        callbackBook?(index)
    }
    
}
