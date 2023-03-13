//
//  Validate.swift
//  
//
//  Created by Igor on 13.03.2023.
//

import Foundation

public extension Http{
    
    /// Set of validate rules for Http client
    enum Validate {
        /// Set of validate rules for  HTTPURLResponse.statusCode
        case status(Status)
    }
}

internal extension Http.Validate{
    
    /// Pick up status validate rule
    var isStatus : Status{
        switch(self){
            case .status(let rule) : return rule
        }
    }
}


internal extension Collection where Element == Http.Validate{
    
    /// Pick up status validate rules
    /// - Returns: Set of fn to validate status
    func filterStatus() -> [Http.Validate.Status] {
        map{ $0.isStatus }
    }
}

