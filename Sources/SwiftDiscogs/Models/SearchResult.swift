//
//  SearchResult.swift
//  
//
//  Created by Stefan Klein Nulent on 02/04/2022.
//

import Foundation

public struct SearchResult: Identifiable {
    
    // MARK: - Properties
    
    public let id: Int
    public let title: String
    public let year: String?
    public let catno: String
    public let format: [String]
    public let genre: [String]
    public let style: [String]
    public let thumbnailUrl: URL?
    
    public var formatsDescription: String {
        format.joined(separator: ", ")
    }
    
    
    
    // MARK: - Construction
    
    init(_ searchResult: RSearchResult) {
        id = searchResult.id
        title = searchResult.title
        year = searchResult.year
        catno = searchResult.catno
        format = searchResult.format
        genre = searchResult.genre
        style = searchResult.style
        thumbnailUrl = URL(searchResult.thumbnail)
    }
    
}
