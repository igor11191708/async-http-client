//
//  HttpMethod.swift
//  
//
//  Created by Igor on 22.02.2023.
//

import Foundation


extension Http{
    
    /// HTTP defines a set of request methods to indicate the desired action to be performed for a given resource. Although they can also be nouns, these request methods are sometimes referred to as HTTP verbs. Each of them implements a different semantic, but some common features are shared by a group of them
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public enum Method: String, Hashable, CustomStringConvertible {
        
        ///The GET method requests a representation of the specified resource. Requests using GET should only retrieve data
        case get = "GET"
        
        ///The POST method submits an entity to the specified resource, often causing a change in state or side effects on the server
        case post = "POST"
        
        ///The PUT method replaces all current representations of the target resource with the request payload
        case put = "PUT"
        
        ///The DELETE method deletes the specified resource
        case delete = "DELETE"
        
        ///The HEAD method asks for a response identical to a GET request, but without the response body
        case head = "HEAD"
        
        ///The OPTIONS method describes the communication options for the target resource
        case option = "OPTIONS"
        
        ///The PATCH method applies partial modifications to a resource
        case patch = "PATCH"        
        
        public var description: String {
                return self.rawValue
            }
    }
}
