//
//  SendHelper.swift
//  
//
//  Created by Igor on 11.03.2023.
//

import Foundation
import retry_policy_service

/// - Parameters:
///   - request: A URL load request that is independent of protocol or URL scheme
///   - retry: ``RetryService`` strategy
///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
internal func sendRetry(
    with request : URLRequest,
    retry strategy : RetryService.Strategy,
    _ taskDelegate: ITaskDelegate? = nil,
    _ session : URLSession = .shared
) async throws -> (Data, URLResponse)
{
    let service = RetryService(strategy: strategy)

    for delay in service.dropLast(){
        do{
            return try await session.data(for: request, delegate: taskDelegate)
        }catch{
            #if DEBUG
            print("retry send \(delay)")
            #endif
        }
        
        try? await Task.sleep(nanoseconds: delay)
    }

    #if DEBUG
    //print("retry send last")
    #endif
    
    /// one more time to let the error to propagate if it fails the last time
    return try await session.data(for: request, delegate: taskDelegate)
}
