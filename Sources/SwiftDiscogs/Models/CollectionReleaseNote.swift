//
//  CollectionReleaseNote.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

extension CollectionRelease {
    public struct Note: Decodable {
        
        // MARK: - Types
        
        enum CodingKeys: String, CodingKey {
            case fieldId = "field_id"
            case value
        }
        
        
        
        // MARK: - Properties
        
        public let fieldId: Int
        public let value: String
    }
}
