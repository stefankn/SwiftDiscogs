//
//  Label.swift
//  
//
//  Created by Stefan Klein Nulent on 23/03/2022.
//

import Foundation

public struct Label {
    
    // MARK: - Properties
    
    let name: String
    let catno: String
    
    
    
    // MARK: - Construction
    
    init(_ label: RLabel) {
        name = label.name
        catno = label.catno
    }
}
