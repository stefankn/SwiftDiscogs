//
//  Track.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

public struct Track: Decodable, Identifiable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case position
        case title
        case duration
        case extraArtists = "extraartists"
    }
    
    
    
    // MARK: - Properties
    
    public let position: String
    public let title: String
    public let duration: String
    public let extraArtists: [Artist]?
    
    
    // MARK: Identifiable Properties
    
    public var id: String {
        position
    }
}
