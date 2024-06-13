
import Fluent
import Vapor

final class Tag: Model, Content {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Keys.name)
    var name: String
    
    @OptionalField(key: Keys.description)
    var description: String?
    
    @Siblings(through: FabricTag.self, from: \.$tag, to: \.$fabric)
    public var fabrics: [Fabric]
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Keys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, name: String, description: String?) {
        self.id = id
        self.name = name
        self.description = description
    }
}

extension Tag {
    enum Keys {
        static let schema = "tags"
        
        static let name: FieldKey = .name
        static let description: FieldKey = .description
        static let createdAt: FieldKey = .createdAt
        static let updatedAt: FieldKey = .updatedAt
    }
}
