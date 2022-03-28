//
//  RFormat.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

struct RFormat: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case name
        case quantity = "qty"
        case text
        case descriptions
    }
    
    
    
    // MARK: - Properties
    
    let name: String
    let quantity: String
    let text: String?
    let descriptions: [String]?
}
