//
//  Proxy+.swift
//  
//
//  Created by Igor on 22.02.2023.
//

import Foundation

// MARK: - Public

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension Http.Proxy where  R == JsonReader, W == JsonWriter{
    
    /// Create proxy from base url
    /// - Parameter baseURL: Base url
    init(baseURL: URL){
        let config =  Http.Configuration<R,W>(baseURL: baseURL)
        self.init(config: config)
    }
}
