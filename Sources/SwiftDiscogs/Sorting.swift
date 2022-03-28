//
//  Sorting.swift
//  
//
//  Created by Stefan Klein Nulent on 25/03/2022.
//

import Foundation

public struct Sorting: Hashable, CaseIterable, Codable {
    
    // MARK: - Constants
    
    public static var allCases: [Sorting] {
        Key.allCases.flatMap{ key in Order.allCases.map{ Sorting(key: key, order: $0) } }
    }
    
    

    // MARK: - Types
    
    public enum Key: String, CaseIterable, Codable {
        case added
        case artist
        case title
    }

    public enum Order: String, CaseIterable, Codable {
        case ascending = "asc"
        case descending = "desc"
    }
    
    
    
    // MARK: - Properties
    
    public let key: Key
    public let order: Order
    
    var parameters: Service.Parameters {
        [
            ("sort", key.rawValue),
            ("sort_order", order.rawValue)
        ]
    }
    
    
    
    // MARK: - Functions
    
    public static func added(_ order: Order) -> Sorting {
        Sorting(key: .added, order: order)
    }
    
    public static func artist(_ order: Order) -> Sorting {
        Sorting(key: .artist, order: order)
    }
    
    public static func title(_ order: Order) -> Sorting {
        Sorting(key: .title, order: order)
    }
}
