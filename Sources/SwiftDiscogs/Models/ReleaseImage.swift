//
//  ReleaseImage.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

extension Release {
    public struct Image: Decodable, Identifiable {
        
        // MARK: - Types
        
        enum CodingKeys: String, CodingKey {
            case type
            case uri
            case thumbnail = "uri150"
        }
        
        
        // MARK: - Private Properties
        
        private let uri: String?
        private let thumbnail: String
        
        
        
        // MARK: - Properties
        
        public let type: String
        public var url: URL? {
            URL(uri)
        }
        
        public var thumbnailURL: URL? {
            URL(thumbnail)
        }
        
        
        // MARK: Identifiable Properties
        
        public var id: String {
            thumbnail
        }
    }
}
