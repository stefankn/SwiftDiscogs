//
//  Artist.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct Artist: Decodable, CustomStringConvertible, Hashable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thumbnail = "thumbnail_url"
        case role
    }
    
    
    
    // MARK: - Properties
    
    public let id: Int
    public let name: String
    public let thumbnail: String?
    public let role: String?
    
    public var thumbnailURL: URL? {
        URL(thumbnail)
    }
    
    
    // MARK: CustomStringConvertible Properties
    
    public var description: String {
        if let role = role {
            return "\(role) - \(name)"
        } else {
            return name
        }
    }
}
