//
//  CollectionFolder.swift
//  
//
//  Created by Stefan Klein Nulent on 10/03/2023.
//

import Foundation

public struct CollectionFolder: Decodable, Identifiable, Hashable, Comparable {
    
    // MARK: - Properties
    
    public let id: Int
    public let name: String
    public let count: Int
    
    
    
    // MARK: - Functions
    
    // MARK: Comparable Functions
    
    public static func < (lhs: CollectionFolder, rhs: CollectionFolder) -> Bool {
        lhs.id < rhs.id
    }
    
    
    // MARK: Hashable Functions
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
