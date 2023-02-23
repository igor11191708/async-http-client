//
//  IWriter.swift
//
//  Created by Igor Shelopaev on 28.04.2021.
//

import Foundation

/// Processes data fetched from a remote source
public protocol IWriter: Sendable {
    
    /// Parses data loaded from remote source
    /// - Parameter data: set of data
    func write<T : Encodable>(_ items: T) throws -> Data
}
