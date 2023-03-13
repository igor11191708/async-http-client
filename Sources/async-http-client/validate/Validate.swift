//
//  Validate.swift
//  
//
//  Created by Igor on 13.03.2023.
//

import Foundation

public extension Http{
    
    /// Set of  rules for validating  Http client
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    enum Validate {
        /// Set of  rules for validating  HTTPURLResponse.statusCode
        case status(Status)
    }
}

internal extension Http.Validate{
    
    /// Pick up status validate rule
    var pickStatusRule : Status{
        switch(self){
            case .status(let rule) : return rule
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
internal extension Collection where Element == Http.Validate{
    
    /// Pick up  rules for validating  HTTPURLResponse.statusCode
    /// - Returns: Collection of rules for validating  statusCode
    func pickStatusRules() -> [Http.Validate.Status] {
        map{ $0.pickStatusRule }
    }
}

