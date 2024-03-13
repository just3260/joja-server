//
//  File.swift
//  
//
//  Created by Andrew on 2024/3/7.
//

import Foundation
import Vapor

struct AdminCheck: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        guard let user = request.auth.get(User.self), user.isAdmin else {
            throw Abort(.unauthorized)
        }
        return try await next.respond(to: request)
    }
}
