//
//  Identifier.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

public struct Identifier {
    
    // MARK: - Properties
    
    let type: String
    let value: String
    let description: String?
    
    
    
    // MARK: - Construction
    
    init(_ identifier: RIdentifier) {
        type = identifier.type
        value = identifier.value
        description = identifier.description
    }
}
