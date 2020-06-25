//
//  TransactionData.swift
//  WORX
//
//  Created by Jaelhorton on 6/6/20.
//  Copyright © 2020 worx. All rights reserved.
//

import Foundation

struct TransactionResponse: Decodable{
    let data: [TransactionData]
}
struct TransactionData: Decodable{
    let id: Int
    let event_name: String
    let created_at: String
    let amount: String

}
