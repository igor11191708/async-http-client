//
//  Proxy.swift
//
//  Created by Igor Shelopaev on 29.04.2021.
//

import Foundation


public extension Http{
    
    /// Http client for creating requests to the server
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    struct Proxy<R: IReader, W: IWriter>: IProxy, @unchecked Sendable{
        
        /// An array of name-value pairs for a request
        public typealias Query = [(String, String?)]
        
        /// A dictionary containing all of the HTTP header fields for a request
        public typealias Headers = [String: String]
        
        /// Configuration
        public let config : Configuration<R,W>
        
        /// Http client for creating requests to the server
        /// - Parameter config: Configuration
        public init(config: Configuration<R,W>){
            self.config = config
        }
        
        /// GET request
        /// - Parameters:
        ///   - path: Path
        ///   - query: An array of name-value pairs
        ///   - headers: A dictionary containing all of the HTTP header fields for a request
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func get<T>(
            path: String,
            query : Query? = nil,
            headers : Headers? = nil,
            taskDelegate: ITaskDelegate? = nil
        ) async throws
        -> Http.Response<T> where T: Decodable
        {
            
            let request = try buildURLRequest(for: path, query: query, headers: headers)
            
            return try await send(with: request, taskDelegate)
        }
        
        /// POST requst
        /// - Parameters:
        ///   - path: Path
        ///   - body: The data sent as the message body of a request, such as for an HTTP POST or PUT requests
        ///   - query: An array of name-value pairs
        ///   - headers: A dictionary containing all of the HTTP header fields for a request
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func post<T>(
            path: String,
            body : Encodable? = nil,
            query : Query? = nil,
            headers : Headers? = nil,
            taskDelegate: ITaskDelegate? = nil
        ) async throws
        -> Http.Response<T> where T: Decodable
        {
            let request = try buildURLRequest(for: path, method: .post, query: query, body: body, headers: headers)
            
            return try await send(with: request, taskDelegate)
        }
        
        
        /// PUT requst
        /// - Parameters:
        ///   - path: Path
        ///   - body: The data sent as the message body of a request, such as for an HTTP POST or PUT requests
        ///   - query: An array of name-value pairs
        ///   - headers: A dictionary containing all of the HTTP header fields for a request
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func put<T>(
            path: String,
            body : Encodable? = nil,
            query : Query? = nil,
            headers : Headers? = nil,
            taskDelegate: ITaskDelegate? = nil
        ) async throws
        -> Http.Response<T> where T: Decodable
        {
            let request = try buildURLRequest(for: path, method: .put, query: query, body: body, headers: headers)
            
            return try await send(with: request, taskDelegate)
        }
        
        /// DELETE request
        /// - Parameters:
        ///   - path: Path
        ///   - query: An array of name-value pairs
        ///   - headers: A dictionary containing all of the HTTP header fields for a request
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func delete<T>(
            path: String,
            query : Query? = nil,
            headers : Headers? = nil,
            taskDelegate: ITaskDelegate? = nil
        ) async throws
        -> Http.Response<T> where T: Decodable
        {
            let request = try buildURLRequest(for: path, method: .delete, query: query, headers: headers)
            
            return try await send(with: request, taskDelegate)
        }
        
        
        /// Send custom request based on the specific request instance
        /// - Parameters:
        ///   - request: A URL load request that is independent of protocol or URL scheme
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func send<T>(
            with request : URLRequest,
            _ taskDelegate: ITaskDelegate? = nil) async throws
        -> Http.Response<T> where T : Decodable
        {
            
            let cfg = config
            let reader = cfg.reader
            
            let (data,response) = try await cfg.getSession.data(for: request, delegate: taskDelegate)
            
            let value: T = try reader.read(data: data)
            
            return .init(value: value, data: data, response, request)
        }
    }
}


// MARK: - Private

private extension Http.Proxy{
    
    /// Url buider method
    /// - Parameters:
    ///   - baseURL: Base url
    ///   - path: Path
    ///   - query: An array of name-value pairs
    /// - Returns: A value that identifies the location of a resource
    func buildURL(baseURL: URL, for path: String, query : Query? = nil) throws -> URL{
        
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
        
    /// A URL load request builder method
    /// - Parameters:
    ///   - path: Path
    ///   - method: The HTTP request method
    ///   - query: An array of name-value pairs
    ///   - body: The data sent as the message body of a request, such as for an HTTP POST or PUT requests
    ///   - headers: A dictionary containing all of the HTTP header fields for a request
    /// - Returns: A URL load request
    func buildURLRequest(
        for path: String,
        method : Http.Method = .get,
        query : Query? = nil,
        body : Encodable? = nil,
        headers : Headers?
        
    ) throws -> URLRequest {
        //url + query
        let url = try buildURL(baseURL: config.baseURL, for: path, query: query)
        
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
                request.setValue(content, forHTTPHeaderField: "Content-Type") // for PUT
            }
        }

        return request
    }
    
    /// Check presents of the content type header
    /// - Parameters:
    ///   - session: URLSession
    ///   - request: URLRequest
    /// - Returns: true - content-type header is not empty
    func hasNotContentType(_ session : URLSession,_ request : URLRequest) -> Bool{
        request.value(forHTTPHeaderField: "Content-Type") == nil &&
        session.configuration.httpAdditionalHeaders?["Content-Type"] == nil
    }
}
