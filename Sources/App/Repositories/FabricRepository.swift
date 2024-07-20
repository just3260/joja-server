
import Vapor
import Fluent

protocol FabricRepository: Repository {
    func create(_ fabric: Fabric) async throws
    func delete(id: UUID) async throws
    func page(with page: PageRequest) async throws -> Page<Fabric>
    func find(id: UUID) async throws -> Fabric?
    func findAll(in sn: String) async throws -> [Fabric]
    func addTag(in fabirc: Fabric, with tag: Tag) async throws
    func store(fabirc: Fabric, in storage: Storage, with quantity: Int) async throws
    func updateImage(with images: [String], in fabricID: UUID) async throws
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
    
    func page(with page: PageRequest) async throws -> Page<Fabric> {
        try await Fabric.query(on: database)
//            .sort(\.$createdAt, .descending)
            .page(withIndex: page.page, size: page.per)
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
    
    func addTag(in fabirc: Fabric, with tag: Tag) async throws {
        try await fabirc.$tags.attach(tag, on: database)
    }
    
    func store(fabirc: Fabric, in storage: Storage, with quantity: Int) async throws {
        try await fabirc.$storages.attach(storage, on: database) { pivot in
            pivot.location = storage.location
            pivot.stock = quantity
        }
    }
    
    func updateImage(with images: [String], in fabricID: UUID) async throws {
//        guard let fabric = try await Fabric.query(on: database)
//            .filter(\.$id == fabricID)
//            .first() else {
//            throw JojaError.modelNotFound(type: "Fabric", id: fabricID.uuidString)
//        }
        
        try await Fabric.query(on: database)
            .set(\.$images, to: images)
            .filter(\.$id == fabricID)
            .update()
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
