//
//  UrlHelper.swift
//  
//
//  Created by Igor on 11.03.2023.
//

import Foundation
import retry_policy_service

/// Url builder method
/// - Parameters:
///   - url:  url
///   - query: An array of name-value pairs
/// - Returns: A value that identifies the location of a resource
internal func append(_ url: URL,with query : Http.Query? = nil) throws -> URL{
    
    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true)else{
        throw URLError(.badURL)
    }
    
    if let query = query, query.isEmpty == false {
        components.queryItems = query.map(URLQueryItem.init) }
    
    guard let url = components.url else { throw URLError(.badURL) }
    
    return url
}
    
/// Url builder method
/// - Parameters:
///   - baseURL: Base url
///   - path: Path
///   - query: An array of name-value pairs
/// - Returns: A value that identifies the location of a resource
internal func buildURL(baseURL: URL, for path: String, query : Http.Query? = nil) throws -> URL{
    
    guard let url = URL(string: path, relativeTo: baseURL)else{
        throw URLError(.badURL)
    }
    
    return try append(url, with: query)
}
