
import Vapor
import JOJACore
import Fluent

extension Tag {
    func makePublic() throws -> TagAPIModel.Response {
        return TagAPIModel.Response(
            id: try self.requireID(),
            name: self.name,
            description: self.description
        )
    }
}

extension TagAPIModel: Content, Connectable {
    func asPublic() throws -> TagAPIModel.Response {
        TagAPIModel.Response(
            id: id,
            name: name,
            description: description
        )
    }
}

extension TagAPIModel {
    init(tag: Tag) throws {
        try self.init(
            id: tag.requireID(),
            name: tag.name,
            description: tag.description
        )
    }
}

extension TagAPIModel.Request {
    func createTag() throws -> Tag {
        Tag(
            name: name,
            description: description
        )
    }
}

extension TagAPIModel.Response: Content, Connectable {}
