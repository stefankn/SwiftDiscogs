//
//  RIdentifier.swift
//  
//
//  Created by Stefan Klein Nulent on 26/03/2022.
//

import Foundation

struct RIdentifier: Decodable {
    
    // MARK: - Properties
    
    let type: String
    let value: String
    let description: String?
}
