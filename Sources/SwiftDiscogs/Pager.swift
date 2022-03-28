//
//  Pager.swift
//  
//
//  Created by Stefan Klein Nulent on 21/03/2022.
//

import Foundation

public struct Pager<Item> {
    
    // MARK: - Properties
    
    public let perPage: Int
    public let pages: Int
    public let page: Int
    public let itemCount: Int
    public let firstURL: URL?
    public let previousURL: URL?
    public let nextUrl: URL?
    public let lastUrl: URL?

    public let items: [Item]
    
    
    
    // MARK: - Construction

    init(_ items: [Item], pagination: Pagination) {
        perPage = pagination.perPage
        pages = pagination.pages
        page = pagination.page
        itemCount = pagination.items
        firstURL = URL(pagination.first)
        previousURL = URL(pagination.previous)
        nextUrl = URL(pagination.next)
        lastUrl = URL(pagination.last)
        
        self.items = items
    }
}
