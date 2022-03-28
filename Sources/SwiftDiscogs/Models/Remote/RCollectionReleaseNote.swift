//
//  RCollectionReleaseNote.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

extension RCollectionRelease {
    struct Note: Decodable {
        
        // MARK: - Types
        
        enum CodingKeys: String, CodingKey {
            case fieldId = "field_id"
            case value
        }
        
        
        
        // MARK: - Properties
        
        let fieldId: Int
        let value: String
    }
}
