//
//  Proxy+.swift
//  
//
//  Created by Igor on 22.02.2023.
//

import Foundation

// MARK: - Public

public extension Http.Proxy where  R == JsonReader, W == JsonWriter{
    
    /// Create proxy from base url
    /// - Parameter baseURL: Base url
    init(baseURL: URL){
        let config =  Http.Configuration<R,W>(baseURL: baseURL)
        self.init(config: config)
    }
}
