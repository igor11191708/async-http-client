//
//  Proxy.swift
//
//  Created by Igor Shelopaev on 28.04.2021.
//

import Foundation

/// Defines a communication layer with a remote source of data
public protocol IProxy {

    associatedtype Config : IConfiguration
    
    /// Configuration
    var config : Config { get }
    
}
