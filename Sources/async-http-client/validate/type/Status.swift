//
//  Status.swift
//  
//
//  Created by Igor on 13.03.2023.
//

import Foundation

public extension Http.Validate{
    
    /// Set of validate cases for Response status code
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    enum Status: IValidate{
        
        public typealias Predicate = (Int) -> Bool
        
        public typealias ErrorFn = (Int, URLResponse, Data?) -> Error?
        
        /// Validate by exact value
        case const(Int = 200)
        
        /// Validate by range
        case range(Range<Int> = 200..<300)
        
        /// Validate by predicate func if you need some specific logic
        case predicate(Predicate)
        
        ///  Check status and emit error if status is not valid
        case check(ErrorFn)
    }
}


// MARK: - Life circle

/// A type that can be initialized with an integer literal.
extension Http.Validate.Status: ExpressibleByIntegerLiteral {
    /// Creates an instance initialized to the specified integer value.
    public init(integerLiteral value: Int) {
       self = .const(value)
    }
}

    // MARK: - API
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension Http.Validate.Status{
    
    /// Validate status
    /// - Parameter data: URLResponse
    func validate(_ response : URLResponse, with data : Data?) throws{
        
        guard let status = (response as? HTTPURLResponse)?.statusCode else{ return try err(nil, response, with: data) }
        
        switch(self){
            case .const(let value):
                if value != status {  try err(status, response, with: data) }
            case .range(let value) :
                if !value.contains(status) { try err(status, response, with: data) }
            case .predicate(let fn):
                if !fn(status) { try err(status, response, with: data) }
            case .check(let checkFn):
                if let error = checkFn(status, response, data){
                    throw error
                }
        }
    }
}

// MARK: - Public

/// Validate status
/// - Parameters:
///   - response: URLResponse
///   - validate: Set of func to validate status code
/// - Throws: Http.Errors.status(response)
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public func validateStatus(
    _ response : URLResponse,
    by rule : Http.Validate.Status,
    with data : Data? = nil
) throws{
    try rule.validate(response, with: data)
}


/// Validate status
/// - Parameters:
///   - response: URLResponse
///   - validate: Set of func to validate status code
/// - Throws: Http.Errors.status(response)
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public func validateStatus(
    _ response : URLResponse,
    by rules : [Http.Validate.Status],
    with data : Data? = nil
) throws {
    try rules.forEach{
        try validateStatus(response, by: $0, with: data)
    }
}

// MARK: - File private

fileprivate func err(
    _ status: Int?, _ response : URLResponse, with data : Data?
)throws{
    throw Http.Errors.status(status, response, data)
}
