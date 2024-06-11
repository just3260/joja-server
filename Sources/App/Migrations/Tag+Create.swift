
import Fluent

extension Tag {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(Tag.schema)
                .id()
                .field(Tag.Keys.name, .string, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Tag.schema)
                .delete()
        }
    }
}
