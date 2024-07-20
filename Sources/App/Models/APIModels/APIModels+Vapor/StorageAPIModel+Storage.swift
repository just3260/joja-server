
import Vapor
import JOJACore
import Fluent

extension Storage {
    func makePublic() throws -> StorageAPIModel.Response {
        return StorageAPIModel.Response(
            id: try self.requireID(),
            name: self.name,
            location: self.location,
            description: self.description
        )
    }
}

extension StorageAPIModel: Content, Connectable {
    func asPublic() throws -> StorageAPIModel.Response {
        StorageAPIModel.Response(
            id: id,
            name: name,
            location: location,
            description: description
        )
    }
}

extension StorageAPIModel {
    init(storage: Storage) throws {
        try self.init(
            id: storage.requireID(),
            name: storage.name,
            location: storage.location,
            description: storage.description
        )
    }
}

extension StorageAPIModel.Request {
    func createStorage() throws -> Storage {
        Storage(
            name: location.getName(),
            location: location,
            description: description
        )
    }
}

extension StorageAPIModel.Response: Content, Connectable {}
