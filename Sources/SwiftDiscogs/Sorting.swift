//
//  Sorting.swift
//  
//
//  Created by Stefan Klein Nulent on 25/03/2022.
//

import Foundation

public struct Sorting: Hashable, Identifiable, Codable {
    
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
    
    
    // MARK: Identifiable Properties
    
    public var id: String {
        key.rawValue + order.rawValue
    }
    
    
    
    // MARK: - Construction
    
    public init(key: Key, order: Order) {
        self.key = key
        self.order = order
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
