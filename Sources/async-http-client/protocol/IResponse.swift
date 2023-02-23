//
//  Response.swift
//
//  Created by Igor Shelopaev on 29.04.2021.
//

import Foundation

/// Defines a response from the remoute source
public protocol IResponse {
        
    /// Raw data
    var data: Data { get }

}

