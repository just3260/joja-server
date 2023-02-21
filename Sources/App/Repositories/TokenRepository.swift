
import Vapor
import Fluent

protocol TokenRepository: Repository {
    func create(_ token: Token) -> EventLoopFuture<Void>
    func find(id: UUID?) -> EventLoopFuture<Token?>
    func find(token: String) -> EventLoopFuture<Token?>
    func delete(_ token: Token) -> EventLoopFuture<Void>
    func count() -> EventLoopFuture<Int>
    func delete(for userID: UUID) -> EventLoopFuture<Void>
}

struct DatabaseTokenRepository: TokenRepository, DatabaseRepository {
    let database: Database
    
    func create(_ token: Token) -> EventLoopFuture<Void> {
        return token.create(on: database)
    }
    
    func find(id: UUID?) -> EventLoopFuture<Token?> {
        return Token.find(id, on: database)
    }
    
    func find(token: String) -> EventLoopFuture<Token?> {
        return Token.query(on: database)
            .filter(\.$value == token)
            .first()
    }
    
    func delete(_ token: Token) -> EventLoopFuture<Void> {
        token.delete(on: database)
    }
    
    func count() -> EventLoopFuture<Int> {
        return Token.query(on: database)
            .count()
    }
    
    func delete(for userID: UUID) -> EventLoopFuture<Void> {
        Token.query(on: database)
            .filter(\.$user.$id == userID)
            .delete()
    }
}

extension Application.Repositories {
    var tokens: TokenRepository {
        guard let factory = storage.makeTokenRepository else {
            fatalError("RefreshToken repository not configured, use: app.repositories.use")
        }
        return factory(app)
    }
    
    func use(_ make: @escaping (Application) -> (TokenRepository)) {
        storage.makeTokenRepository = make
    }
}
