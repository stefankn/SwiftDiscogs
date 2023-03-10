//
//  Video.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

public struct Video: Decodable, Identifiable {
    
    // MARK: - Private Properties
    
    private let uri: String
    
    
    
    // MARK: - Properties
    
    public let title: String
    public let description: String
    public let duration: Int
    
    public var url: URL? {
        URL(uri)
    }
    
    
    // MARK: Identifiable Properties
    
    public var id: String {
        uri
    }
}
