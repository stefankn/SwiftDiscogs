//
//  Track.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

public struct Track {
    
    // MARK: - Properties
    
    public let position: String
    public let type: String
    public let title: String
    public let duration: String
    public let extraArtists: [Artist]
    
    
    
    // MARK: - Construction
    
    init(_ track: RTrack) {
        position = track.position
        type = track.type
        title = track.title
        duration = track.duration
        extraArtists = track.extraArtists?.map(Artist.init) ?? []
    }
}
