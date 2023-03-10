//
//  SearchResult.swift
//  
//
//  Created by Stefan Klein Nulent on 02/04/2022.
//

import Foundation

public struct SearchResult: Decodable, Identifiable {
    
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
    
    
    
    // MARK: - Private Properties
    
    private let thumbnail: String?
    
    
    
    // MARK: - Properties
    
    public let id: Int
    public let title: String
    public let year: String?
    public let catno: String
    public let format: [String]
    public let genre: [String]
    public let style: [String]
    
    public var thumbnailUrl: URL? {
        URL(thumbnail)
    }
    
    public var formatsDescription: String {
        format.joined(separator: ", ")
    }
}
