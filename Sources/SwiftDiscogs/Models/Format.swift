//
//  Format.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

public struct Format: Decodable, CustomStringConvertible {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case name
        case quantity = "qty"
        case text
        case descriptions
    }
    
    
    
    // MARK: - Properties
    
    public let name: String
    public let quantity: String
    public let text: String?
    public let descriptions: [String]?
    
    
    // MARK: CustomStringConvertible Properties
    
    public var description: String {
        var format: String
        if let quantity = Int(quantity), quantity > 1 {
            format = "\(quantity)x \(name)"
        } else {
            format = name
        }
        
        return ([format] + (descriptions ?? [])).joined(separator: ", ")
    }
}
