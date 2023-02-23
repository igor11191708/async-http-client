//
//  Response.swift
//  
//
//  Created by Igor on 22.02.2023.
//

import Foundation

public extension Http{
    
    /// The metadata associated with the response to a URL load request
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 6.0, *)
    struct Response<T> : IResponse{
        
        /// Instances of a data
        public let value: T
                
        /// Raw data set
        public let data: Data
                
        /// Response
        public let urlRresponse: URLResponse
                
        /// Request
        public let urlRequest: URLRequest
                
        /// Status code
        public var statusCode: Int? {
            (urlRresponse as? HTTPURLResponse)?.statusCode
        }
        
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
            self.urlRresponse = urlRresponse
            self.urlRequest = urlRequest
        }
        
    }
}
