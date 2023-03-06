//
//  RetryService.swift
//  
//
//  Created by Igor on 06.03.2023.
//

import Foundation


/// Generate sequence of time delays between retries depending on retry strategy
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RetryService: Equatable, Sequence{
        
    /// Retry strategy
    public let strategy: Strategy       
    
    /// Default service
    static let `default` = RetryService(strategy: .exponential())
    
    
    /// - Parameter strategy: Retry strategy ``RetryService.Strategy``
    public init(strategy: Strategy){
        self.strategy = strategy
    }
        
    /// Max amount of retires
    var maximumRetries: UInt{
        strategy.maximumRetries
    }
    
    /// Duration between retries For .exponential multiply on the amount of the current retries
    var duration: TimeInterval{
        strategy.duration
    }
       
    /// - Returns: Retry delays iterator
    public func makeIterator() -> RetryIterator {
        return RetryIterator(service: self)
    }
}




