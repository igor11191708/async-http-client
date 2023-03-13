//
//  IValidate.swift
//  
//
//  Created by Igor on 13.03.2023.
//

import Foundation


/// Define rule for validating URLResponse specs
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
protocol IValidate{
    
    /// Validate
    /// - Parameter data: URLResponse
    func validate(_ data : URLResponse) throws
}
