//
//  URL+Utilities.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

extension URL {
    
    // MARK: - Construction
    
    init?(_ string: String?) {
        if let string = string, let url = URL(string: string) {
            self = url
        } else {
            return nil
        }
    }
}
