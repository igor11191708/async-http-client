//
//  UrlHelper.swift
//  
//
//  Created by Igor on 17.03.2023.
//

import XCTest
@testable import async_http_client


final class UrlHelper: XCTestCase {
    
    let urlString = "http://localhost:3000"
    
    func testBuildURL() throws{
        
        let url = URL(string: urlString)!
        
        let userEndpoint = try buildURL(baseURL: url, for: "user")
        
        XCTAssertEqual(userEndpoint.absoluteString, "http://localhost:3000/user")
    }
    
    func testAppend() throws{
        
        let url = URL(string: urlString)!
        let query = [("user","Name")]
        let userEndpoint = try append(url, with: query)
        
        XCTAssertEqual(userEndpoint.absoluteString, "http://localhost:3000?user=Name")
    }

}
