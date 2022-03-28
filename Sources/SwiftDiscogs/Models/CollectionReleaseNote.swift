//
//  CollectionReleaseNote.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

extension CollectionRelease {
    public struct Note {
        
        // MARK: - Properties
        
        public let fieldId: Int
        public let value: String
        
        
        
        // MARK: - Construction
        
        init(_ note: RCollectionRelease.Note) {
            fieldId = note.fieldId
            value = note.value
        }
    }
}
