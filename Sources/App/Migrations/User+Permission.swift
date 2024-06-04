
import FluentKit

extension User {
    struct AddPermission: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(User.schema)
                .field(User.Keys.permissions, .int, .required, .sql(.default(0)))
                .update()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(User.schema)
                .deleteField(User.Keys.permissions)
                .update()
        }
    }
}
