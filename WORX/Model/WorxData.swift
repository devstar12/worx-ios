//
//  WorxData.swift
//  WORX
//
//  Created by Jaelhorton on 6/4/20.
//  Copyright © 2020 worx. All rights reserved.
//

import Foundation

struct WorxResponse: Decodable{
    let data: WorxData?
}
struct WorxData: Decodable{
    let success: Bool
    let msg: String?
}
