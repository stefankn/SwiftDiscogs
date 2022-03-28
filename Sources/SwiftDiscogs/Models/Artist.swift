//
//  Artist.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct Artist {
    
    // MARK: - Properties
    
    public let id: Int
    public let name: String
    public let thumbnail: URL?
    
    
    
    // MARK: - Construction
    
    init(_ artist: RArtist) {
        id = artist.id
        name = artist.name
        thumbnail = URL(artist.thumbnail)
    }
}
