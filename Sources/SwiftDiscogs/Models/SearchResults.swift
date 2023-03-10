//
//  SearchResults.swift
//  
//
//  Created by Stefan Klein Nulent on 02/04/2022.
//

import Foundation

struct SearchResults: Decodable {
    
    // MARK: - Properties
    
    let pagination: Pagination
    let results: [SearchResult]
}
