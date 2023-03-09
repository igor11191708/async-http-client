//
//  Proxy.swift
//
//  Created by Igor Shelopaev on 29.04.2021.
//

import Foundation
import retry_policy_service

public extension Http{
    
    /// Http client for creating requests to the server
    /// Proxy does not keep any state It's just a transport layer to get and pass data
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
        ///   - retry: Amount of attempts Default value .exponential with 5 retry and duration 2.0
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func get<T>(
            path: String,
            query : Query? = nil,
            headers : Headers? = nil,
            retry : UInt = 1,
            taskDelegate: ITaskDelegate? = nil
        ) async throws
        -> Http.Response<T> where T: Decodable
        {
            
            let request = try buildURLRequest(for: path, query: query, headers: headers)
            let strategy = RetryService.Strategy.exponential(retry: retry)
            
            return try await send(with: request, retry: strategy, taskDelegate)
        }
        
        /// POST request
        /// - Parameters:
        ///   - path: Path
        ///   - body: The data sent as the message body of a request, such as for an HTTP POST or PUT requests
        ///   - query: An array of name-value pairs
        ///   - headers: A dictionary containing all of the HTTP header fields for a request
        ///   - retry: Amount of attempts Default value .exponential with 5 retry and duration 2.0
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func post<T>(
            path: String,
            body : Encodable? = nil,
            query : Query? = nil,
            headers : Headers? = nil,
            retry : UInt = 1,
            taskDelegate: ITaskDelegate? = nil
        ) async throws
        -> Http.Response<T> where T: Decodable
        {
            let request = try buildURLRequest(for: path, method: .post, query: query, body: body, headers: headers)
            let strategy = RetryService.Strategy.exponential(retry: retry)
            
            return try await send(with: request, retry: strategy, taskDelegate)
        }
        
        
        /// PUT request
        /// - Parameters:
        ///   - path: Path
        ///   - body: The data sent as the message body of a request, such as for an HTTP POST or PUT requests
        ///   - query: An array of name-value pairs
        ///   - headers: A dictionary containing all of the HTTP header fields for a request
        ///   - retry: Amount of attempts Default value .exponential with 5 retry and duration 2.0
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func put<T>(
            path: String,
            body : Encodable? = nil,
            query : Query? = nil,
            headers : Headers? = nil,
            retry : UInt = 1,
            taskDelegate: ITaskDelegate? = nil
        ) async throws
        -> Http.Response<T> where T: Decodable
        {
            let request = try buildURLRequest(for: path, method: .put, query: query, body: body, headers: headers)
            let strategy = RetryService.Strategy.exponential(retry: retry)
            
            return try await send(with: request, retry: strategy, taskDelegate)
        }
        
        /// DELETE request
        /// - Parameters:
        ///   - path: Path
        ///   - query: An array of name-value pairs
        ///   - headers: A dictionary containing all of the HTTP header fields for a request
        ///   - retry: Amount of attempts Default value .exponential with 5 retry and duration 2.0
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func delete<T>(
            path: String,
            query : Query? = nil,
            headers : Headers? = nil,
            retry : UInt = 1,
            taskDelegate: ITaskDelegate? = nil
        ) async throws
        -> Http.Response<T> where T: Decodable
        {
            let request = try buildURLRequest(for: path, method: .delete, query: query, headers: headers)
            let strategy = RetryService.Strategy.exponential(retry: retry)
            return try await send(with: request, retry: strategy, taskDelegate)
        }
        
        
        /// Send custom request based on the specific request instance
        /// - Parameters:
        ///   - request: A URL load request that is independent of protocol or URL scheme
        ///   - retry: ``RetryService.Strategy`` strategy Default value .exponential with 5 retry and duration 2.0
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func send<T>(
            with request : URLRequest,
            retry strategy : RetryService.Strategy = .exponential(),
            _ taskDelegate: ITaskDelegate? = nil
        ) async throws -> Http.Response<T> where T : Decodable
        {
            
            let reader = config.reader
            
            let (data,response) = try await sendRetry(
                with: request,
                retry: strategy,
                taskDelegate
            )
            
            let value: T = try reader.read(data: data)
            
            return .init(value: value, data: data, response, request)
        }
    }
}


// MARK: - Private

private extension Http.Proxy{
    
    /// - Parameters:
    ///   - request: A URL load request that is independent of protocol or URL scheme
    ///   - retry: ``RetryService`` strategy
    ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
    func sendRetry(
        with request : URLRequest,
        retry strategy : RetryService.Strategy,
        _ taskDelegate: ITaskDelegate? = nil
    ) async throws -> (Data, URLResponse)
    {
        
        let session = config.getSession
        let service = RetryService(strategy: strategy)

        for delay in service.dropLast(){
            do{
                return try await session.data(for: request, delegate: taskDelegate)
            }catch{
                #if DEBUG
                print("retry send \(delay)")
                #endif
            }
            
            try? await Task.sleep(nanoseconds: delay)
        }

        #if DEBUG
        //print("retry send last")
        #endif
        
        /// one more time to let the error to propagate if it fails the last time
        return try await session.data(for: request, delegate: taskDelegate)
    }
    
    /// Url builder method
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
