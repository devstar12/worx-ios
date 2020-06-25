//
//  LoginResponse.swift
//  WORX
//
//  Created by Jaelhorton on 5/21/20.
//  Copyright © 2020 worx. All rights reserved.
//

import Foundation
struct LoginResponse: Decodable{
    let token: String?
    let data: LoginData
}
struct LoginData: Decodable{
    let user: UserProfile
    let match_count: Int?
}
struct UserProfile: Decodable{
    let id: Int
    let email: String
    let first_name: String?
    let last_name: String?
    let birthday: String?
    let photo: String?
    let credits: String?
    let created_at: String?
    let updated_at: String?

}
struct DeleteResponse: Decodable{
    let success: Bool
}
