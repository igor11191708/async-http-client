//
//  RetryIterator.swift
//  
//
//  Created by Igor on 06.03.2023.
//

import Foundation


public extension RetryService{
    
    /// Retry iterator
     @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
     struct RetryIterator: IteratorProtocol {
         
         /// Current amount of retries
        public private(set) var retries: UInt = 1
         
         /// Retry service
        public let service: RetryService
         
         /// - Parameter service: Retry service ``RetryService``
        init(service: RetryService){
            self.service = service
        }

        /// Returns the next delay amount, or `nil`.
        public mutating func next() -> TimeInterval? {

            let max = service.maximumRetries
            let time = service.duration
            
            guard time > 0 else{ return nil }
            
            guard max > retries && max != 0 else { return nil }
            
            defer { retries += 1 }
            
            let delay: TimeInterval
            
            switch service.strategy {
                case .constant(_, let duration):
                    delay = duration
                case .exponential(_, let duration):
                    delay = duration * Double(retries)
            }

            return delay
        }
    }
}
