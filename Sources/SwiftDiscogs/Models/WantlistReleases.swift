//
//  WantlistReleases.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

struct WantlistReleases: Decodable {
    
    // MARK: - Properties
    
    let pagination: Pagination
    let wants: [WantlistRelease]
}
