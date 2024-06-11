
import Fluent
import Vapor

final class Tag: Model, Content {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Keys.name)
    var name: String
    
    @Siblings(through: FabricTag.self, from: \.$tag, to: \.$fabric)
    public var fabrics: [Fabric]
    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension Tag {
    enum Keys {
        static let schema = "tags"
        
        static let name: FieldKey = .name
    }
}
