//
//  AuthManager.swift
//  CIUWApp
//
//  Created by Jaelhorton on 5/14/20.
//  Copyright © 2020 ciuw. All rights reserved.
//

import Foundation

class AuthManager {
    static let sharedInstance = AuthManager()
    var accessToken = ""
    var userProfile: UserProfile?
    private init() { }
    
    enum LoginError: Error {
        case invalidCredentials
        case lockedOut
        case other(originalError: Error)
    }
    
    enum RegisterError: Error {
        case existingemail
        case passwordnotmatched
        case other(originalError: Error)
    }

    /*
     Login Functions
     */
    func login(email: String, password: String, completion: @escaping (UserProfile?, LoginError?) -> Void) {
        WORXAPI.sharedInstance.login(withEmail: email, withPassword: password) { (result, error) in
            if let error = error?.asAFError, error.responseCode == 401 {
                completion(nil, .invalidCredentials)
            }
            else if let error = error {
                completion(nil, .other(originalError: error))
            }
            else if let result = result{
                //self.accessToken = result.token
                self.userProfile = result.data.user
                // Save User Profile
                PrefsManager.setUserID(val: self.userProfile?.id ?? 0)
                PrefsManager.setEmail(val: self.userProfile?.email ?? "")
                PrefsManager.setFirstName(val: self.userProfile?.first_name ?? "")
                PrefsManager.setLastName(val: self.userProfile?.last_name ?? "")
                PrefsManager.setAvatar(val: self.userProfile?.photo ?? "")
                PrefsManager.setPassword(val: password)
                completion(self.userProfile, nil)
            }
        }
    }
    func register(email: String, password: String, firstname: String, lastname: String, birthday: String, photo: String, completion: @escaping (UserProfile?, RegisterError?) -> Void) {
        
        WORXAPI.sharedInstance.register(withEmail: email, withPassword: password, withFirstName: firstname, withLastName: lastname, withBirthday: birthday, withPhoto: photo) { (result, error) in
            if let error = error?.asAFError, error.responseCode == 401 {
                completion(nil, .existingemail)
            }
            else if let error = error {
                completion(nil, .other(originalError: error))
            }
            else if let result = result{
                //self.accessToken = result.token
                self.userProfile = result.data.user
                // Save User Profile
                PrefsManager.setUserID(val: self.userProfile?.id ?? 0)
                PrefsManager.setEmail(val: self.userProfile?.email ?? "")
                PrefsManager.setFirstName(val: self.userProfile?.first_name ?? "")
                PrefsManager.setLastName(val: self.userProfile?.last_name ?? "")
                PrefsManager.setAvatar(val: self.userProfile?.photo ?? "")
                PrefsManager.setPassword(val: password)

                completion(self.userProfile, nil)
            }
        }
    }
}
