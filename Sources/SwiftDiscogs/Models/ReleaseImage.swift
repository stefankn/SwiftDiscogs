//
//  ReleaseImage.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

extension Release {
    public struct Image: Identifiable {
        
        // MARK: - Properties
        
        public let type: String
        public let url: URL
        public let thumbnail: URL
        
        
        // MARK: Identifiable Properties
        
        public var id: URL {
            url
        }
        
        
        
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
