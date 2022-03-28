//
//  AnyPublisher+Utilities.swift
//  
//
//  Created by Stefan Klein Nulent on 20/03/2022.
//

import Foundation
import Combine

extension AnyPublisher {
    
    // MARK: - Functions
    
    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        Just(output).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }
    
    static func failure(_ error: Failure) -> AnyPublisher<Output, Failure> {
        Fail(error: error).eraseToAnyPublisher()
    }
}
