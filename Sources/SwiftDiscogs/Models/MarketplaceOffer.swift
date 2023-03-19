//
//  MarketplaceOffer.swift
//  
//
//  Created by Stefan Klein Nulent on 18/03/2023.
//

import Foundation
import SwiftCore

public struct MarketplaceOffer: Comparable, Identifiable {
    
    // MARK: - Properties
    
    public let url: URL
    public let title: String
    public let priceDescription: String
    public let price: Double
    public let seller: String
    public let message: String?
    public let updatedAt: Date
    
    
    // MARK: Identifiable Properties
    
    public var id: URL {
        url
    }
    
    
    
    // MARK: - Construction
    
    init?(_ element: XMLElement) {
        if
            let urlString = element.firstText(by: .offerId), let url = URL(string: urlString),
            let title = element.firstText(by: .offerTitle),
            let summary = element.firstText(by: .offerSummary),
            let updatedString = element.firstText(by: .offerUpdated), let updatedAt = ISO8601DateFormatter().date(from: updatedString) {
            
            self.url = url
            self.title = title
            self.updatedAt = updatedAt
            
            var summaryComponents = summary.split(separator: " - ")
            if summaryComponents.count > 0 {
                self.priceDescription = String(summaryComponents.removeFirst())
                if let priceString = self.priceDescription.split(separator: " ").last, let price = Double(priceString) {
                    self.price = price
                } else {
                    return nil
                }
            } else {
                return nil
            }
            
            if summaryComponents.count > 0 {
                self.seller = String(summaryComponents.removeFirst()).replacingOccurrences(of: " -", with: "")
            } else {
                return nil
            }
            
            if summaryComponents.count > 0 {
                let message = String(summaryComponents.removeFirst())
                if !message.isEmpty {
                    self.message = message
                } else {
                    self.message = nil
                }
            } else {
                message = nil
            }
            
        } else {
            return nil
        }
    }
    
    
    
    // MARK: - Functions
    
    // MARK: Comparable Functions
    
    public static func < (lhs: MarketplaceOffer, rhs: MarketplaceOffer) -> Bool {
        lhs.price < rhs.price
    }
}
