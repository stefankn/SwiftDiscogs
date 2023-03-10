//
//  WantlistRelease.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct WantlistRelease: Decodable, Identifiable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case release = "basic_information"
    }
    
    
    
    // MARK: - Properties
    
    public let id: Int
    public let release: Release
}
