//
//  Strategy.swift
//  
//
//  Created by Igor on 06.03.2023.
//

import Foundation

public extension RetryService{
    
    /// Retry strategy
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    enum Strategy: Hashable {
        
        /// constant delay between reties
        case constant(
            retry : UInt = 5,
            duration: TimeInterval = 2.0
        )
        
        /// Exponential backoff is a strategy in which you increase the delays between retries.
        case exponential(
            retry : UInt = 5,
            duration: TimeInterval = 2.0
        )
        
        /// Max amount of retries
        var maximumRetries: UInt{
            switch self{
                case .constant(let retry, _) : return retry
                case .exponential(let retry, _) : return retry
            }
        }
        
        /// Duration between retries For .exponential multiply on the amount of the current retries
        var duration: TimeInterval{
            switch self{
                case .constant(_, let duration) : return duration
                case .exponential(_, let duration) : return duration
            }
        }
    }
}
