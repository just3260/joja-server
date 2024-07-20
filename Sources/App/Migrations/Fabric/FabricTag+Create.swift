
import Fluent

extension FabricTag {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(FabricTag.schema)
                .id()
                .field(FabricTag.Keys.fabricId, .uuid, .required)
                .field(FabricTag.Keys.tagId, .uuid, .required)
                .field(FabricTag.Keys.createdAt, .datetime)
                .foreignKey(
                    FabricTag.Keys.fabricId,
                    references: Fabric.schema, .id,
                    onDelete: .cascade,
                    onUpdate: .cascade
                )
                .foreignKey(
                    FabricTag.Keys.tagId,
                    references: Tag.schema, .id,
                    onDelete: .cascade,
                    onUpdate: .cascade
                )
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
