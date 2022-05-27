//
//  Video.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

public struct Video: Identifiable {
    
    // MARK: - Properties
    
    public let url: URL
    public let title: String
    public let description: String
    public let duration: Int
    
    
    // MARK: Identifiable Properties
    
    public var id: URL {
        url
    }
    
    
    
    // MARK: - Construction
    
    init?(_ video: RVideo) {
        if let url = URL(video.uri) {
            self.url = url
            title = video.title
            description = video.description
            duration = video.duration
        } else {
            return nil
        }
    }
}
