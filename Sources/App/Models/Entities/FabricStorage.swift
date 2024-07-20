
import Fluent
import Vapor
import JOJACore

final class FabricStorage: Model, Content, @unchecked Sendable {
    
    static let schema = Keys.schema

    @ID(key: .id)
    var id: UUID?

    @Parent(key: Keys.fabricId)
    var fabric: Fabric

    @Parent(key: Keys.storageId)
    var storage: Storage
    
    @Enum(key: Keys.location)
    var location: TypeAPIModel.Location
    
    @Field(key: Keys.stock)
    var stock: Int
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Keys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, fabric: Fabric, storage: Storage) throws {
        self.id = id
        self.$fabric.id = try fabric.requireID()
        self.$storage.id = try storage.requireID()
    }
}

extension FabricStorage {
    enum Keys {
        static let schema = "fabric+storage"
        
        static let fabricId: FieldKey = .fabricId
        static let storageId: FieldKey = .storageId
        static let location: FieldKey = .location
        static let stock: FieldKey = .stock
        static let createdAt: FieldKey = .createdAt
        static let updatedAt: FieldKey = .updatedAt
    }
}
