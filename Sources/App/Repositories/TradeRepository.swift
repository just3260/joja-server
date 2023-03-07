
import Vapor
import Fluent

protocol TradeRepository: Repository {
    func create(_ trade: Trade) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [Trade]
    func find(id: UUID) async throws -> Trade?
//    func find(email: String) async throws -> Trade?
    func count() async throws -> Int
}

struct DatabaseTradeRepository: TradeRepository, DatabaseRepository {
    let database: Database
    
    func create(_ trade: Trade) async throws {
        try await trade.create(on: database)
    }
    
    func delete(id: UUID) async throws {
        try await Trade.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() async throws -> [Trade] {
        try await Trade.query(on: database).all()
    }
    
    func find(id: UUID) async throws -> Trade? {
        try await Trade.find(id, on: database)
    }
    
//    func find(email: String) async throws -> Trade? {
//        try await Trade.query(on: database)
//            .filter(\.$email == email)
//            .first()
//    }
    
    func count() async throws -> Int {
        try await Trade.query(on: database).count()
    }
}

extension Application.Repositories {
    var trades: TradeRepository {
        guard let storage = storage.makeTradeRepository else {
            fatalError("TradeRepository not configured, use: app.tradeRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (TradeRepository)) {
        storage.makeTradeRepository = make
    }
}
