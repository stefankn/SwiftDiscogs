//
//  Pagination.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

struct Pagination: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case pages
        case page
        case items
        case urls
    }
    
    enum UrlsCodingKeys: String, CodingKey {
        case first
        case previous = "prev"
        case next
        case last
    }
    
    
    
    // MARK: - Properties
    
    let perPage: Int
    let pages: Int
    let page: Int
    let items: Int
    let first: String?
    let previous: String?
    let next: String?
    let last: String?
    
    
    
    // MARK: - Construction
    
    // MARK: Decodable Construction
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        perPage = try container.decode(Int.self, forKey: .perPage)
        page = try container.decode(Int.self, forKey: .page)
        pages = try container.decode(Int.self, forKey: .pages)
        items = try container.decode(Int.self, forKey: .items)
        
        let urlsContainer = try container.nestedContainer(keyedBy: UrlsCodingKeys.self, forKey: .urls)
        first = try urlsContainer.decodeIfPresent(String.self, forKey: .first)
        previous = try urlsContainer.decodeIfPresent(String.self, forKey: .previous)
        next = try urlsContainer.decodeIfPresent(String.self, forKey: .next)
        last = try urlsContainer.decodeIfPresent(String.self, forKey: .last)
    }
    
}
