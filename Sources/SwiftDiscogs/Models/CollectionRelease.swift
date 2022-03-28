//
//  CollectionRelease.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct CollectionRelease: Identifiable {
    
    // MARK: - Properties
    
    public let id: Int
    public let instanceId: Int
    public let folderId: Int
    public let release: Release
    public let notes: [Note]
    
    
    
    // MARK: - Construction
    
    init(_ collectionRelease: RCollectionRelease) {
        id = collectionRelease.id
        instanceId = collectionRelease.instanceId
        folderId = collectionRelease.folderId
        release = Release(collectionRelease.release)
        notes = collectionRelease.notes.map(CollectionRelease.Note.init)
    }
}
