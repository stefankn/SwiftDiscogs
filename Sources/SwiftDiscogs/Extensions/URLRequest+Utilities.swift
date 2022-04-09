//
//  URLRequest+Utilities.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation

extension URLRequest {
    
    // MARK: - Types
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    
    
    // MARK: - Construction
    
    init(method: Method, url: URL) {
        self.init(url: url)
        httpMethod = method.rawValue
    }
}
