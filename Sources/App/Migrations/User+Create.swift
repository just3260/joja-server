
import FluentKit

extension User {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(User.schema)
                .id()
                .field(User.Keys.name, .string, .required)
                .field(User.Keys.email, .string, .required)
                .field(User.Keys.password, .string, .required)
                .field(User.Keys.isAdmin, .bool, .required, .custom("DEFAULT FALSE"))
                .field(User.Keys.createdAt, .datetime)
                .field(User.Keys.updatedAt, .datetime)
                .unique(on: User.Keys.name, User.Keys.email, name: "user_unique_setting")
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(User.schema)
                .delete()
        }
    }
}
