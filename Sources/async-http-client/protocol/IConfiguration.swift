//
//  IConfiguration.swift
//  
//
//  Created by Igor on 22.02.2023.
// https://github.com/apple/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md

import Foundation

/// ``Sendable`` - A type whose values can safely be passed across concurrency domains by copying
public protocol IConfiguration: Sendable{
    
    associatedtype Reader : IReader
    
    associatedtype Writer : IWriter
    
    /// An object that decodes instances of a data type from JSON objects
    var reader: Reader { get }
    
    /// An object that encodes instances of a data type as JSON objects
    var writer: Writer { get }
}
