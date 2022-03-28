//
//  Format.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

public struct Format {
    
    // MARK: - Properties
    
    public let name: String
    public let quantity: String
    public let text: String?
    public let descriptions: [String]
    
    
    
    // MARK: - Construction
    
    init(_ format: RFormat) {
        name = format.name
        quantity = format.quantity
        text = format.text
        descriptions = format.descriptions ?? []
    }
}
