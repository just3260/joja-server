//
//  File.swift
//  
//
//  Created by Andrew on 2024/6/3.
//

import Foundation
import Vapor
import JOJACore

struct PermissionCheck: AsyncMiddleware {
    let permission: PermissionOptions

    public init(permission: PermissionOptions) {
        self.permission = permission
    }

    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        guard let user = request.auth.get(User.self) else {
            throw Abort(.unauthorized)
        }
        guard PermissionOptions(rawValue: user.permissions).contains(permission) || user.isAdmin else {
            throw JojaError.insufficientPermission()
        }
        return try await next.respond(to: request)
    }
}
