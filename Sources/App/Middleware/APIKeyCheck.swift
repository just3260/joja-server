//
//  File.swift
//  
//
//  Created by Andrew on 2023/1/31.
//

import Foundation
import Vapor

// Development and Test key 4310f636-43ec-41ba-aa34-b3e3c378d987

struct APIKeyCheck: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        guard let apiKey: String = request.headers["x-api-key"].first,
              let storedKey = Environment.get("API_KEY"),
              apiKey == storedKey
        else {
            throw Abort(.unauthorized)
        }
        return try await next.respond(to: request)
    }
}
