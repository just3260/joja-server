
import Foundation
import Fluent
import JOJACore

extension Trade {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            try await database
                .schema(Trade.schema)
                .id()
                .field(Trade.Keys.amount, .int, .required)
                .field(Trade.Keys.note, .string)
                .field(Trade.Keys.description, .string)
                .field(Trade.Keys.buyerID, .uuid, .required, .references(Member.schema, .id, onDelete: .cascade))
                .field(Trade.Keys.createdAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Trade.schema)
                .delete()
        }
    }
}
