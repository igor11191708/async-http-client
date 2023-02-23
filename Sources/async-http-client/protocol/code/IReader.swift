//
//  IReader.swift
//
//  Created by Igor Shelopaev on 28.04.2021.
//

import Foundation

/// Processes data fetched from a remote source
public protocol IReader: Sendable {
    
    /// Parses data loaded from remote source
    /// - Parameter data: set of data
    func read<T: Decodable>(data: Data) throws -> T
}
