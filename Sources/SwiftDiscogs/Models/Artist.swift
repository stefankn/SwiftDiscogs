//
//  Artist.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct Artist: CustomStringConvertible, Hashable {
    
    // MARK: - Properties
    
    public let id: Int
    public let name: String
    public let thumbnail: URL?
    public let role: String?
    
    
    // MARK: CustomStringConvertible Properties
    
    public var description: String {
        if let role = role {
            return "\(role) - \(name)"
        } else {
            return name
        }
    }
    
    
    
    // MARK: - Construction
    
    init(_ artist: RArtist) {
        id = artist.id
        name = artist.name
        thumbnail = URL(artist.thumbnail)
        role = artist.role
    }
}
