//
//  HTTPURLResponse+Utilities.swift
//  
//
//  Created by Stefan Klein Nulent on 28/03/2022.
//

import Foundation

extension HTTPURLResponse {
    
    // MARK: - Types
    
    struct HTTPStatus: Equatable {
        let code: Int
        
        var isSuccess: Bool {
            200 ..< 300 ~= code
        }
        
        var isClientError: Bool {
            400 ..< 500 ~= code
        }
        
        var isServerError: Bool {
            500 ..< 600 ~= code
        }

        public init(_ code: Int) {
            self.code = code
        }
    }
    
    
    
    // MARK: - Properties
    
    var status: HTTPStatus {
        HTTPStatus(statusCode)
    }
}
