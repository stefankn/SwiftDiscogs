//
//  RWantlistReleases.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

struct RWantlistReleases: Decodable {
    
    // MARK: - Properties
    
    let pagination: Pagination
    let wants: [RWantlistRelease]
}
