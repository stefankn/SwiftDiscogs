//
//  RCollectionReleases.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

struct RCollectionReleases: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case pagination
        case items = "releases"
    }
    
    
    
    // MARK: - Properties
    
    let pagination: Pagination
    let items: [RCollectionRelease]
}
