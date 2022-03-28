//
//  WantlistRelease.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct WantlistRelease: Identifiable {
    
    // MARK: - Properties
    
    public let id: Int
    public let release: Release
    
    
    
    // MARK: - Construction
    
    init(_ wantlistRelease: RWantlistRelease) {
        id = wantlistRelease.id
        release = Release(wantlistRelease.release)
    }
}
