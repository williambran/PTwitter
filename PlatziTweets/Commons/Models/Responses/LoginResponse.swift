//
//  LoginResponse.swift
//  PlatziTweets
//
//  Created by mac1 on 01/07/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let user: User
    let token: String
}
