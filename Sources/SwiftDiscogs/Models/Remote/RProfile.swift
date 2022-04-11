//
//  RProfile.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation

struct RProfile: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case avatarURL = "avatar_url"
        case collectionCount = "num_collection"
        case wantlistCount = "num_wantlist"
    }
    
    
    
    // MARK: - Properties
    
    let id: Int
    let username: String
    let avatarURL: String?
    let collectionCount: Int
    let wantlistCount: Int
}
