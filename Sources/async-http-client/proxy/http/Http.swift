//
//  Http.swift
//  
//
//  Created by Igor on 22.02.2023.
//

import Foundation

public struct Http{

    /// An array of name-value pairs for a request
    public typealias Query = [(String, String?)]
    
    /// A dictionary containing all of the HTTP header fields for a request
    public typealias Headers = [String: String]
    
    // MARK: - Static
    
    /// Url buider method
    /// - Parameters:
    ///   - baseURL: Base url
    ///   - path: Path
    ///   - query: An array of name-value pairs
    /// - Returns: A value that identifies the location of a resource
    static func buildURL(baseURL: URL, for path: String, query : Http.Query? = nil) throws -> URL{
        
        guard let url = URL(string: path, relativeTo: baseURL)else{
            throw URLError(.badURL)
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true)else{
            throw URLError(.badURL)
        }
        
        if let query = query, query.isEmpty == false {
            components.queryItems = query.map(URLQueryItem.init) }
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        return url
    }
    
    
    /// A URL load request buider method
    /// - Parameters:
    ///   - config: Configuration
    ///   - path: Path
    ///   - method: The HTTP request method
    ///   - query: An array of name-value pairs
    ///   - body: The data sent as the message body of a request, such as for an HTTP POST or PUT requests
    ///   - headers: A dictionary containing all of the HTTP header fields for a request
    /// - Returns: A URL load request
    static func buildURLRequest<R,W>(
        config : Configuration<R,W>,
        for path: String,
        method : Http.Method = .get,
        query : Query? = nil,
        body : Encodable? = nil,
        headers : Headers?
        
    ) throws -> URLRequest {
        //url + query
        let url = try Http.buildURL(baseURL: config.baseURL, for: path, query: query)
        
        var request = URLRequest(url: url)
        
        //headers
        if let headers{
            request.allHTTPHeaderFields = headers
        }
        
        // method
        request.httpMethod = method.rawValue
        
        //body
        if let body = body{
            request.httpBody = try config.writer.write(body)
            
            if hasNotContentType(config.getSession, request){
                let content = config.defaultContentType
                request.setValue(content, forHTTPHeaderField: "Content-Type")
            }
        }
        
        return request
    }
    
    
    /// Check presents of the content type header
    /// - Parameters:
    ///   - session: URLSession
    ///   - request: URLRequest
    /// - Returns: true - header is not empty
    static func hasNotContentType(_ session : URLSession,_ request : URLRequest) -> Bool{
        request.value(forHTTPHeaderField: "Content-Type") == nil &&
        session.configuration.httpAdditionalHeaders?["Content-Type"] == nil
    }
}
