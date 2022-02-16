//
//  LoginRequest.swift
//  PlatziTweets
//
//  Created by mac1 on 01/07/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import Foundation


struct LoginRequest: Codable {
    let email: String
    let password: String
}
