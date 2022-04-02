//
//  Release.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct Release: CustomStringConvertible {
    
    // MARK: - Properties
    
    public let id: Int
    public let title: String
    public let year: Int
    public let thumbnailUrl: URL?
    public let artists: [Artist]
    public let labels: [Label]
    public let formats: [Format]
    public let genres: [String]
    public let styles: [String]
    public let videos: [Video]
    public let identifiers: [Identifier]
    public let tracks: [Track]
    public let images: [Image]
    public let note: String?
    
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
        genres.joined(separator: ", ")
    }
    
    public var stylesDescription: String {
        styles.joined(separator: ", ")
    }
    
    
    // MARK: CustomStringConvertible Properties
    
    public var description: String {
        "\(artistsDescription) - \(title)"
    }
    
    
    
    // MARK: - Construction
    
    init(_ release: RRelease) {
        id = release.id
        title = release.title
        year = release.year
        thumbnailUrl = URL(release.thumbnail)
        artists = release.artists.map(Artist.init)
        labels = release.labels.map(Label.init)
        formats = release.formats.map(Format.init)
        genres = release.genres ?? []
        styles = release.styles ?? []
        videos = release.videos?.compactMap(Video.init) ?? []
        identifiers = release.identifiers?.map(Identifier.init) ?? []
        tracks = release.tracks?.map(Track.init) ?? []
        images = release.images?.compactMap(Image.init) ?? []
        note = release.note
    }
}
