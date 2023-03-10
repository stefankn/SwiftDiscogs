//
//  Release.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct Release: Decodable, Identifiable, CustomStringConvertible {
    
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
        case notes
    }
    
    
    // MARK: - Private Properties
    
    private let thumbnail: String?
    
    
    
    // MARK: - Properties
    
    public let id: Int
    public let title: String
    public let year: Int
    public let artists: [Artist]
    public let labels: [Label]
    public let formats: [Format]
    public let genres: [String]?
    public let styles: [String]?
    public let videos: [Video]?
    public let identifiers: [Identifier]?
    public let tracks: [Track]?
    public let images: [Image]?
    public let notes: String?
    
    public var thumbnailURL: URL? {
        URL(thumbnail)
    }
    
    public var artistsDescription: String {
        artists.map{ $0.name }.joined(separator: ", ")
    }
    
    public var catnoDescription: String {
        labels.map{ $0.catno }.joined(separator: ", ")
    }
    
    public var formatsDescription: String {
        formats.map{ "\($0)" }.joined(separator: ", ")
    }
    
    public var genresDescription: String {
        (genres ?? []).joined(separator: ", ")
    }
    
    public var stylesDescription: String {
        (styles ?? []).joined(separator: ", ")
    }
    
    
    // MARK: CustomStringConvertible Properties
    
    public var description: String {
        "\(artistsDescription) - \(title)"
    }
}
