//
//  Proxy.swift
//
//  Created by Igor Shelopaev on 28.04.2021.
//

import Foundation

/// Defines a communication layer with a remote source of data
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 6.0, *)
public protocol IProxy {

    associatedtype Config : IConfiguration
    
    /// Configuration
    var config : Config { get }
    
}
