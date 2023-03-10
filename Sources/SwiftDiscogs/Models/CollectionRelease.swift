//
//  CollectionRelease.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct CollectionRelease: Decodable, Identifiable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case folderId = "folder_id"
        case release = "basic_information"
        case notes
    }
    
    
    
    // MARK: - Properties
    
    public let id: Int
    public let instanceId: Int
    public let folderId: Int
    public let release: Release
    public let notes: [Note]?
}
