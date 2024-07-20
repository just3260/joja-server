
import Fluent
import JOJACore

extension FabricStorage {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let locationType = try await database.enum(TypeAPIModel.Location.getKey()).read()
            
            try await database
                .schema(FabricStorage.schema)
                .id()
                .field(FabricStorage.Keys.fabricId, .uuid, .required)
                .field(FabricStorage.Keys.storageId, .uuid, .required)
                .field(Storage.Keys.location, locationType, .required)
                .field(FabricStorage.Keys.stock, .int)
                .field(FabricStorage.Keys.createdAt, .datetime)
                .field(FabricStorage.Keys.updatedAt, .datetime)
                .foreignKey(
                    FabricStorage.Keys.fabricId,
                    references: Fabric.schema, .id,
                    onDelete: .cascade,
                    onUpdate: .cascade
                )
                .foreignKey(
                    FabricStorage.Keys.storageId,
                    references: Storage.schema, .id,
                    onDelete: .cascade,
                    onUpdate: .cascade
                )
                .unique(on: FabricStorage.Keys.fabricId, FabricStorage.Keys.storageId)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(FabricStorage.schema)
                .delete()
        }
    }
}
