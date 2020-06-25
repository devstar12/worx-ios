//
//  DateHeaderCell.swift
//  WORX
//
//  Created by Jaelhorton on 5/20/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit

class DateHeaderCell: UICollectionViewCell {
    private let label = UILabel()
    private let indicator = UIView()

    var text: String! {
        didSet {
            label.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select(didSelect: Bool, activeColor: UIColor, inActiveColor: UIColor){
        indicator.backgroundColor = activeColor
        
        if didSelect {
            label.textColor = activeColor
            indicator.isHidden = false
        }else{
            label.textColor = inActiveColor
            indicator.isHidden = true
        }
    }
    
    private func setupUI(){
        // view
        self.addSubview(label)
        self.addSubview(indicator)
        
        // label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.font = UIFont.systemFont(ofSize: 18)
        
        // indicator
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        indicator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}
