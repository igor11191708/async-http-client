//
//  Response.swift
//
//  Created by Igor Shelopaev on 29.04.2021.
//

import Foundation

/// Defines a response from the remote source
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 6.0, *)
public protocol IResponse {
        
    /// Raw data
    var data: Data { get }

}

