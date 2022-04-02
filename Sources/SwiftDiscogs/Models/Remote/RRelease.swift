//
//  RRelease.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

struct RRelease: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case thumbnail = "thumb"
        case artists
        case labels
        case formats
        case genres
        case styles
        case videos
        case identifiers
        case tracks = "tracklist"
        case images
        case note
    }
    
    
    
    // MARK: - Properties
    
    let id: Int
    let title: String
    let year: Int
    let thumbnail: String?
    let artists: [RArtist]
    let labels: [RLabel]
    let formats: [RFormat]
    let genres: [String]?
    let styles: [String]?
    let videos: [RVideo]?
    let identifiers: [RIdentifier]?
    let tracks: [RTrack]?
    let images: [Image]?
    let note: String?
}
