
import Fluent
import Vapor

final class FabricTag: Model, Content, @unchecked Sendable {
    
    static let schema = Keys.schema

    @ID(key: .id)
    var id: UUID?

    @Parent(key: Keys.fabricId)
    var fabric: Fabric

    @Parent(key: Keys.tagId)
    var tag: Tag
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, fabric: Fabric, tag: Tag) throws {
        self.id = id
        self.$fabric.id = try fabric.requireID()
        self.$tag.id = try tag.requireID()
    }
}

extension FabricTag {
    enum Keys {
        static let schema = "fabric+tag"
        
        static let fabricId: FieldKey = .fabricId
        static let tagId: FieldKey = .tagId
        static let createdAt: FieldKey = .createdAt
    }
}
