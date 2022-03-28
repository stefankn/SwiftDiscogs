//
//  RReleaseImage.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

extension RRelease {
    struct Image: Decodable {
        
        // MARK: - Types
        
        enum CodingKeys: String, CodingKey {
            case type
            case uri
            case thumbnail = "uri_150"
        }
        
        
        
        // MARK: - Properties
        
        let type: String
        let uri: String
        let thumbnail: String
    }
}
