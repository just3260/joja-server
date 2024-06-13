
import Fluent

extension Tag {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(Tag.schema)
                .id()
                .field(Tag.Keys.name, .string, .required)
                .field(Tag.Keys.description, .string)
                .field(Tag.Keys.createdAt, .datetime)
                .field(Tag.Keys.updatedAt, .datetime)
                .unique(on: Tag.Keys.name)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Tag.schema)
                .delete()
        }
    }
}
