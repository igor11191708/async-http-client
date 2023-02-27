//
//  JsonReader.swift
//
//  Created by Igor Shelopaev on 28.04.2021.
//

import Foundation

/// An object that decodes instances of a data type from JSON objects
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct JsonReader: IReader {
            
    // MARK: - Life circle

    public init() { }

    // MARK: - API Methods

    /// Parse JSON data
    /// - Parameter data: Fetched data
    /// - Returns: Returns a value of the type you specify, decoded from a JSON object.
    public func read<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
