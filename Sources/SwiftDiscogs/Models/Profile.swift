//
//  Profile.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct Profile: Decodable, Identifiable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case avatar = "avatar_url"
        case collectionCount = "num_collection"
        case wantlistCount = "num_wantlist"
    }
    
    
    
    // MARK: - Properties
    
    public let id: Int
    public let username: String
    public let avatar: String?
    public let collectionCount: Int
    public let wantlistCount: Int
    
    public var avatarURL: URL? {
        URL(avatar)
    }
    
}
