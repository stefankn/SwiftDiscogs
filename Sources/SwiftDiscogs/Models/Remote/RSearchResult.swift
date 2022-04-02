//
//  RSearchResult.swift
//  
//
//  Created by Stefan Klein Nulent on 02/04/2022.
//

import Foundation

public struct RSearchResult: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case catno
        case format
        case genre
        case style
        case thumbnail = "thumb"
    }
    
    
    
    // MARK: - Properties
    
    let id: Int
    let title: String
    let year: String
    let catno: String
    let format: [String]
    let genre: [String]
    let style: [String]
    let thumbnail: String?
}
