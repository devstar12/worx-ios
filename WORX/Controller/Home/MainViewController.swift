//
//  MainViewController.swift
//  WORX
//
//  Created by Jaelhorton on 5/18/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import SwiftIcons
class MainViewController: UITabBarController, UITabBarControllerDelegate {

    private var middleButton = UIButton()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        let image = UIImage(named: "background_tabbar")
        let tabView = UIImageView(image: image)
        tabView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tabBar.addSubview(tabView)
        self.tabBar.sendSubviewToBack(tabView)
//        let tabBarImage = resize(image: image!, newWidth: self.view.frame.width)
//        self.tabBar.backgroundImage = tabBarImage
 */
        /*
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .default
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
*/        
        self.selectedIndex = 1
        /*
        guard let tabItems = self.tabBar.items else {return}
        tabItems[1].imageInsets = UIEdgeInsets(top: -20, left: 0, bottom: 20, right: 0)
 */
        setupMiddleButton()
    }
    func setupMiddleButton() {

        middleButton.frame.size = CGSize(width: 100, height: 100)
        middleButton.imageView?.contentMode = .scaleAspectFill
        middleButton.setImage(UIImage(named: "ic_ball"), for: .normal)
//        middleButton.backgroundColor = .blue
//        middleButton.layer.cornerRadius = 35
//        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        self.tabBar.addSubview(middleButton)

        self.view.layoutIfNeeded()
    }

    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 1   //to select the middle tab. use "1" if you have only 3 tabs.
    }
    func resize(image: UIImage, newWidth: CGFloat) -> UIImage {

        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: self.view.frame.height))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: self.view.frame.height)) // image.drawInRect( CGRect(x: 0, y: 0, width: newWidth, height: image.size.height))  in swift 2
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
