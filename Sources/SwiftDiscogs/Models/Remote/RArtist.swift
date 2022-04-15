//
//  RArtist.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

struct RArtist: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thumbnail = "thumbnail_url"
        case role
    }
    
    
    
    // MARK: - Properties
    
    let id: Int
    let name: String
    let thumbnail: String?
    let role: String?
}
