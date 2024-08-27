
import Fluent
import JOJACore

extension Member {
    struct FillAt: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let whereType = try await database.enum(TypeAPIModel.WhereToKnow.getKey()).read()
            
            try await database
                .schema(Member.schema)
                .field(Member.Keys.fillAt, .datetime)
                .update()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Member.schema)
                .deleteField(Member.Keys.fillAt)
                .update()
        }
    }
}
