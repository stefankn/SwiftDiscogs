//
//  Video.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

public struct Video {
    
    // MARK: - Properties
    
    let url: URL
    let title: String
    let description: String
    let duration: Int
    
    
    
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
