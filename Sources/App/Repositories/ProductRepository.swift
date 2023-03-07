
import Vapor
import Fluent

protocol ProductRepository: Repository {
    func create(_ product: Product) async throws
    func delete(id: UUID) async throws
    func find(id: UUID) async throws -> Product?
}

struct DatabaseProductRepository: ProductRepository, DatabaseRepository {
    let database: Database
    
    func create(_ product: Product) async throws {
        try await product.create(on: database)
    }
    
    func delete(id: UUID) async throws {
        try await Product.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func find(id: UUID) async throws -> Product? {
        try await Product.find(id, on: database)
    }
}

extension Application.Repositories {
    var products: ProductRepository {
        guard let storage = storage.makeProductRepository else {
            fatalError("ProductRepository not configured, use: app.productRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (ProductRepository)) {
        storage.makeProductRepository = make
    }
}
