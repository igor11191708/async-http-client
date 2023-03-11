//
//  Direct.swift
//  
//
//  Created by Igor on 11.03.2023.
//

import Foundation
import retry_policy_service

public extension Http{
    
    struct Get{
        public static func from(
            _ url : URL,
            query : Http.Query? = nil,
            headers : Http.Headers? = nil,
            retry : UInt = 1,
            taskDelegate: ITaskDelegate? = nil
        ) async throws -> (Data, URLResponse){
            let request = try buildURLRequest(for: url, query: query, headers: headers)
            let strategy = RetryService.Strategy.exponential(retry: retry)
            
           return try await sendRetry(with: request, retry: strategy)
        }
    }
    
    struct Post{
        public static func from(
            _ url : URL,
            query : Http.Query? = nil,
            body : Data? = nil,
            headers : Http.Headers? = nil,
            retry : UInt = 1,
            taskDelegate: ITaskDelegate? = nil
        ) async throws -> (Data, URLResponse){
            let request = try buildURLRequest(for: url, method: .post, query: query, body: body, headers: headers)
            let strategy = RetryService.Strategy.exponential(retry: retry)

           return try await sendRetry(with: request, retry: strategy)
        }
    }
    
    struct Put{
        public static func from(
            _ url : URL,
            query : Http.Query? = nil,
            body : Data? = nil,
            headers : Http.Headers? = nil,
            retry : UInt = 1,
            taskDelegate: ITaskDelegate? = nil
        ) async throws -> (Data, URLResponse){
            let request = try buildURLRequest(for: url, method: .put, query: query, body: body, headers: headers)
            let strategy = RetryService.Strategy.exponential(retry: retry)
            
           return try await sendRetry(with: request, retry: strategy)
        }
    }
    
    struct Delete{
        public static func from(
            _ url : URL,
            query : Http.Query? = nil,
            headers : Http.Headers? = nil,
            retry : UInt = 1,
            taskDelegate: ITaskDelegate? = nil
        ) async throws -> (Data, URLResponse){
            let request = try buildURLRequest(for: url, method: .delete, query: query, headers: headers)
            let strategy = RetryService.Strategy.exponential(retry: retry)
            
           return try await sendRetry(with: request, retry: strategy)
        }
    }
}
