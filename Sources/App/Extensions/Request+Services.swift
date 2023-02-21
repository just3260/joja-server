
import Vapor

extension Request {
    // MARK: Repositories
    var users: UserRepository { application.repositories.users.for(self) }
    var tokens: TokenRepository { application.repositories.tokens.for(self) }
}
