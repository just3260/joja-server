//
//  File.swift
//  
//
//  Created by Andrew on 2023/1/31.
//

import Foundation
import Vapor

final class Logging: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        let res = try await next.respond(to: request)
        
        switch res.status {
        case .movedPermanently:
            request.logger.info("[REDIRECT] \(request.url.path) -> \(res.headers[.location])")
        default:
            break
        }
        
        return res
    }
}
