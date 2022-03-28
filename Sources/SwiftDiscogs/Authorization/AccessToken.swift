//
//  AccessToken.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation

struct AccessToken: Codable {
    
    // MARK: - Properties
    
    let token: String
    let secret: String
}
