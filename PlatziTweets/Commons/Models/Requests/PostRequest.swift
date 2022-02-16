//
//  PostRequest.swift
//  PlatziTweets
//
//  Created by mac1 on 01/07/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import Foundation

struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: PostRequestLocation?
}
