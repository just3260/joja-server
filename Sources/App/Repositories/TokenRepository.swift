
import Vapor
import Fluent

protocol TokenRepository: Repository {
    func create(_ token: Token) async throws
    func save(_ token: Token) async throws
    func find(id: UUID?) async throws -> Token?
    func find(token: String) async throws -> Token?
    func delete(_ token: Token) async throws
    func count() async throws -> Int
    func delete(for userID: UUID) async throws
}

struct DatabaseTokenRepository: TokenRepository, DatabaseRepository {
    let database: Database
    
    func create(_ token: Token) async throws {
        try await token.create(on: database)
    }
    
    func save(_ token: Token) async throws {
        try await token.save(on: database)
    }
    
    func find(id: UUID?) async throws -> Token? {
        try await Token.find(id, on: database)
    }
    
    func find(token: String) async throws -> Token? {
        try await Token.query(on: database)
            .filter(\.$value == token)
            .first()
    }
    
    func delete(_ token: Token) async throws {
        try await token.delete(on: database)
    }
    
    func count() async throws -> Int {
        try await  Token.query(on: database)
            .count()
    }
    
    func delete(for userID: UUID) async throws {
        try await Token.query(on: database)
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
