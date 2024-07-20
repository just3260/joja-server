
import Fluent
import Vapor
import JOJACore

final class Storage: Model, Content, @unchecked Sendable {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Keys.name)
    var name: String
    
    @Enum(key: Keys.location)
    var location: TypeAPIModel.Location
    
    @Siblings(through: FabricStorage.self, from: \.$storage, to: \.$fabric)
    public var fabric: [Fabric]
    
    @OptionalField(key: Keys.description)
    var description: String?
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, name: String, location: TypeAPIModel.Location, description: String?) {
        self.id = id
        self.name = name
        self.location = location
        self.description = description
    }
}

extension Storage {
    enum Keys {
        static let schema = "storages"
        
        static let name: FieldKey = .name
        static let location: FieldKey = .location
        static let description: FieldKey = .description
        static let createdAt: FieldKey = .createdAt
        static let updatedAt: FieldKey = .updatedAt
    }
}
