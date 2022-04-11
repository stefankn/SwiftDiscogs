//
//  Profile.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct Profile {
    
    // MARK: - Properties
    
    public let id: Int
    public let username: String
    public let avatarURL: URL?
    public let collectionCount: Int
    public let wantlistCount: Int
    
    
    
    // MARK: - Construction
    
    init(_ profile: RProfile) {
        id = profile.id
        username = profile.username
        avatarURL = URL(profile.avatarURL)
        collectionCount = profile.collectionCount
        wantlistCount = profile.wantlistCount
    }
    
}
