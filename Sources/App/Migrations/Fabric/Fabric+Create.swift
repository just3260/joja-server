
import Fluent
import JOJACore

extension Fabric {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let materialType = try await database.enum(TypeAPIModel.Material.getKey()).read()
            let cottonType = try await database.enum(TypeAPIModel.CottonMaterial.getKey()).read()
            let ageType = try await database.enum(TypeAPIModel.Age.getKey()).read()
            let designType = try await database.enum(TypeAPIModel.Design.getKey()).read()
            let colorType = try await database.enum(TypeAPIModel.Color.getKey()).read()
//            let locationType = try await database.enum(TypeAPIModel.Location.getKey()).read()
            
            try await database
                .schema(Fabric.schema)
                .id()
                .field(Fabric.Keys.name, .string)
                .field(Fabric.Keys.componentMaterial, materialType, .required)
                .field(Fabric.Keys.componentCottonType, cottonType)
                .field(Fabric.Keys.componentAge, ageType, .required)
                .field(Fabric.Keys.componentDesign, designType, .required)
                .field(Fabric.Keys.componentColor, colorType, .required)
                .field(Fabric.Keys.sn, .string, .required)
                .field(Fabric.Keys.price, .int, .required)
//                .field(Fabric.Keys.buy, .int, .required)
                .field(Fabric.Keys.stock, .int, .required)
//                .field(Fabric.Keys.location, locationType, .required)
                .field(Fabric.Keys.description, .string)
                .field(Fabric.Keys.note, .string)
                .field(Fabric.Keys.images, .array(of: .string), .required)
                .field(Fabric.Keys.createdAt, .datetime)
                .field(Fabric.Keys.updatedAt, .datetime)
                .field(Fabric.Keys.log, .string)
                .unique(on: Fabric.Keys.sn)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Fabric.schema)
                .delete()
        }
    }
}
