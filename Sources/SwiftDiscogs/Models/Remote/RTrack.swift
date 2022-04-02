//
//  RTrack.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

struct RTrack: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case position
        case title
        case duration
        case extraArtists = "extraartists"
    }
    
    
    
    // MARK: - Properties
    
    let position: String
    let title: String
    let duration: String
    let extraArtists: [RArtist]?
}
