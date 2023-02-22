
import FluentKit

extension Token {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(Token.schema)
                .id()
                .field(Token.Keys.userId, .uuid, .references(User.schema, .id))
                .field(Token.Keys.value, .string, .required)
                .field(Token.Keys.source, .int, .required)
                .field(Token.Keys.createdAt, .datetime)
                .field(Token.Keys.expiresAt, .datetime, .required)
                .unique(on: Token.Keys.value, name: "token_unique_setting")
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Token.schema)
                .delete()
        }
    }
}
