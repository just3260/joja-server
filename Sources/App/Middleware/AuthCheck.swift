
import Foundation
import Vapor

struct AuthCheck: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        do {
            try request.auth.require(User.self)
        } catch {
            throw AuthenticationError.refreshTokenOrUserNotFound
        }
        return try await next.respond(to: request)
    }
}
