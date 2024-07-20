
import Vapor
import Fluent

protocol StorageRepository: Repository {
    func create(_ storage: Storage) async throws
    func delete(id: UUID) async throws
    func find(id: UUID) async throws -> Storage?
    func findStorage(name: String) async throws -> Storage?
    func findAll() async throws -> [Storage]
}

struct DatabaseStorageRepository: StorageRepository, DatabaseRepository {
    let database: Database
    
    func create(_ storage: Storage) async throws {
        try await storage.create(on: database)
    }
    
    func delete(id: UUID) async throws {
        try await Storage.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func find(id: UUID) async throws -> Storage? {
        try await Storage.find(id, on: database)
    }
    
    func findStorage(name: String) async throws -> Storage? {
        try await Storage.query(on: database).filter(\.$name == name).first()
    }
    
    func findAll() async throws -> [Storage] {
        try await Storage.query(on: database)
            .all()
    }
}

extension Application.Repositories {
    var storages: StorageRepository {
        guard let storage = storage.makeStorageRepository else {
            fatalError("StorageRepository not configured, use: app.storageRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (StorageRepository)) {
        storage.makeStorageRepository = make
    }
}
