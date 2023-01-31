//
//  File.swift
//  
//
//  Created by Andrew on 2023/1/31.
//

import Foundation
import Vapor

final class Logging: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).map { res in
            
            switch res.status {
//            case .ok:
//                request.logger.info("[200] \(request.url.path)")

            case .movedPermanently:
                request.logger.info("[REDIRECT] \(request.url.path) -> \(res.headers[.location])")
            
            default:
                break
            }
            
            return res
        }
    }
}
