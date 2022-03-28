//
//  ReleaseImage.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

extension Release {
    public struct Image {
        
        // MARK: - Properties
        
        let type: String
        let url: URL
        let thumbnail: URL
        
        
        
        // MARK: - Construction
        
        init?(_ image: RRelease.Image) {
            if let url = URL(image.uri), let thumbnail = URL(image.thumbnail) {
                type = image.type
                self.url = url
                self.thumbnail = thumbnail
            } else {
                return nil
            }
        }
    }
}
