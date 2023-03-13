//
//  Validate.swift
//  
//
//  Created by Igor on 13.03.2023.
//

import Foundation

public extension Http{
    
    /// Set of validate cases for Http client
    enum Validate {
        /// Set of validate cases for  URLResponse  status
        case status(Status)
    }
}

internal extension Http.Validate{
    
    /// Check if validate status
    var isStatus : Status{
        switch(self){
            case .status(let rule) : return rule
        }
    }
}


internal extension Collection where Element == Http.Validate{
    
    /// Filter status validate fn
    /// - Returns: Set of fn to validate status
    func filterStatus() -> [Http.Validate.Status] {
        map{ $0.isStatus }
    }
}

