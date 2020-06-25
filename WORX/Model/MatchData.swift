//
//  MatchData.swift
//  WORX
//
//  Created by Jaelhorton on 5/23/20.
//  Copyright © 2020 worx. All rights reserved.
//

import Foundation
struct MatchResponse: Decodable{
    let data: [MatchData]?
}

struct PlayerData: Decodable{
    let id: Int
    let match_id: String?
    let player_id: String
    let created_at: String?
    let updated_at: String?
    let email: String
    let password: String
    let first_name: String
    let last_name: String
    let birthday: String
    let photo: String
    let credits: String
    let deleted_at: String?
}
struct MatchData: Decodable{
    let id: Int
    let host_photo: String
    let host_name: String
    let title: String
    let start_time: String
    let address: String
    let latitude: String
    let longitude: String
    let rules: String
    let max_players: String
    let reservations: String
    let credits: String
    let players: [PlayerData]?
}
