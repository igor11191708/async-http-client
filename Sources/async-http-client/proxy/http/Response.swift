//
//  Response.swift
//  
//
//  Created by Igor on 22.02.2023.
//

import Foundation

public extension Http{
    
    /// The metadata associated with the response to a URL load request
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    struct Response<T> : IResponse, @unchecked Sendable{
        
        /// Status code
        public var statusCode: Int? {
            (urlResponse as? HTTPURLResponse)?.statusCode
        }
        
        // MARK: - Config
        
        /// Instances of a data
        public let value: T
                
        /// Raw data set
        public let data: Data
                
        /// Response
        public let urlResponse: URLResponse
                
        /// Request
        public let urlRequest: URLRequest

        
        // MARK: - Life circle
        
        /// The metadata associated with the response to a URL load request
        /// - Parameters:
        ///   - value: Instances of a data
        ///   - data: Raw data set
        ///   - urlRresponse: Response
        ///   - urlRequest: Request
        init(
            value: T,
            data: Data,
            _ urlRresponse: URLResponse,
            _ urlRequest: URLRequest)
        {
            self.value = value
            self.data = data
            self.urlResponse = urlRresponse
            self.urlRequest = urlRequest
        }
        
    }
}
