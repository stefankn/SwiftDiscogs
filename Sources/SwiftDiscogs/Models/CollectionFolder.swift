//
//  CollectionFolder.swift
//  
//
//  Created by Stefan Klein Nulent on 10/03/2023.
//

import Foundation

public struct CollectionFolder: Decodable, Identifiable, Hashable {
    
    // MARK: - Properties
    
    public let id: Int
    public let name: String
    public let count: Int
}
