//
//  RegisterRequest.swift
//  PlatziTweets
//
//  Created by mac1 on 01/07/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let names: String
}
