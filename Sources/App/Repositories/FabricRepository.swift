
import Vapor
import Fluent

protocol FabricRepository: Repository {
    func create(_ fabric: Fabric) async throws
    func delete(id: UUID) async throws
    func find(id: UUID) async throws -> Fabric?
    func findAll(in sn: String) async throws -> [Fabric]
}

struct DatabaseFabricRepository: FabricRepository, DatabaseRepository {
    let database: Database
    
    func create(_ fabric: Fabric) async throws {
        try await fabric.create(on: database)
    }
    
    func delete(id: UUID) async throws {
        try await Fabric.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func find(id: UUID) async throws -> Fabric? {
        try await Fabric.find(id, on: database)
    }
    
    func findAll(in sn: String) async throws -> [Fabric] {
        try await Fabric.query(on: database)
            .filter(\.$sn ~~ sn)
            .all()
//            .sort(\.$createdAt, .descending)
    }
}

extension Application.Repositories {
    var fabrics: FabricRepository {
        guard let storage = storage.makeFabricRepository else {
            fatalError("FabricRepository not configured, use: app.fabricRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (FabricRepository)) {
        storage.makeFabricRepository = make
    }
}
