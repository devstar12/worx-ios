//
//  Util.swift
//  CIUWApp
//
//  Created by Jaelhorton on 5/11/20.
//  Copyright © 2020 ciuw. All rights reserved.
//

import Foundation
import SCLAlertView

class Util{
    static func showAlert( _ title: String, _ message: String){
        _ = SCLAlertView().showSuccess(title, subTitle: message, closeButtonTitle:"OK")
    }
    
    static func showError( _ title: String, _ message: String){
        _ = SCLAlertView().showError(title, subTitle: message, closeButtonTitle: "OK")
    }

    static func showWarning( _ title: String, _ message: String){
        _ = SCLAlertView().showWarning(title, subTitle: message, closeButtonTitle: "OK")
    }
    static func showNotice( _ title: String, _ message: String){
        _ = SCLAlertView().showNotice(title, subTitle: message, closeButtonTitle: "OK")
    }
    
    static func showAlert(vc: UIViewController, _ title: String, _ message: String){
        let topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        topWindow?.rootViewController = UIViewController()
        topWindow?.windowLevel = UIWindow.Level.alert + 1
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        ))
        vc.present(alert, animated: true, completion: nil)
    }
    static func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }

}
