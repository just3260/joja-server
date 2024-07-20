
import Fluent
import JOJACore

extension Storage {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let locationType = try await database.enum(TypeAPIModel.Location.getKey()).read()
            
            try await database
                .schema(Storage.schema)
                .id()
                .field(Storage.Keys.name, .string, .required)
                .field(Storage.Keys.location, locationType, .required)
                .field(Storage.Keys.description, .string)
                .field(Storage.Keys.createdAt, .datetime)
                .unique(on: Storage.Keys.location)
                .unique(on: Storage.Keys.name)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Storage.schema)
                .delete()
        }
    }
}
