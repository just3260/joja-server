
import Fluent

extension FabricTag {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(FabricTag.schema)
                .id()
                .field(FabricTag.Keys.fabricId, .uuid, .required)
                .field(FabricTag.Keys.tagId, .uuid, .required)
                .unique(on: FabricTag.Keys.fabricId, FabricTag.Keys.tagId)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(FabricTag.schema)
                .delete()
        }
    }
}
