//
//  RCollectionRelease.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

struct RCollectionRelease: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case folderId = "folder_id"
        case release = "basic_information"
        case notes
    }
    
    
    
    // MARK: - Properties
    
    let id: Int
    let instanceId: Int
    let folderId: Int
    let release: RRelease
    let notes: [Note]?
}
