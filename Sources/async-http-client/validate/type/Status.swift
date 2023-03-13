//
//  Status.swift
//  
//
//  Created by Igor on 13.03.2023.
//

import Foundation

public extension Http.Validate{
    
    /// Set of validate cases for Response status code
    enum Status{
        
        public typealias Predicate = (Int) -> Bool
        
        /// Validate by exact value
        case const(Int = 200)
        
        /// Validate by range
        case range(Range<Int> = 200..<300)
        
        /// Validate by predicate func if you need some specific logic
        case predicate(Predicate)
        
    }
}

/// A type that can be initialized with an integer literal.
extension Http.Validate.Status: ExpressibleByIntegerLiteral {
    /// Creates an instance initialized to the specified integer value.
    public init(integerLiteral value: Int) {
       self = .const(value)
    }
}

public extension Http.Validate.Status{
    
    /// Validate status
    /// - Parameter data: URLResponse
    func validate(_ data : URLResponse) throws{
        
        guard let status = (data as? HTTPURLResponse)?.statusCode else{ return try err(nil, data) }
        
        switch(self){
            case .const(let value):
                if value != status {  try err(status, data) }
            case .range(let value) :
                if !value.contains(status) { try err(status, data) }
            case .predicate(let fn):
                if !fn(status) { try err(status, data) }
        }
    }
}

// MARK: - Public

/// Validate status
/// - Parameters:
///   - response: URLResponse
///   - validate: Set of func to validate status code
/// - Throws: Http.Errors.status(response)
public func validateStatus(_ response : URLResponse, by rule : Http.Validate.Status) throws{
    
    try rule.validate(response)
}


/// Validate status
/// - Parameters:
///   - response: URLResponse
///   - validate: Set of func to validate status code
/// - Throws: Http.Errors.status(response)
public func validateStatus(_ response : URLResponse, by rules : [Http.Validate.Status]) throws{
    
    try rules.forEach{
        try validateStatus(response, by: $0)
    }
}

// MARK: - File private

fileprivate func err(_ status: Int?, _ response : URLResponse) throws{
    throw Http.Errors.status(status, response)
}
