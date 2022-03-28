//
//  RWantlistRelease.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

struct RWantlistRelease: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case release = "basic_information"
    }
    
    
    
    // MARK: - Properties
    
    let id: Int
    let release: RRelease
}
