
import Foundation
import Fluent
import JOJACore

extension Product {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let brandType = try await database.enum(TypeAPIModel.Brand.getKey()).read()
            let goodsType = try await database.enum(TypeAPIModel.Goods.getKey()).read()
            let materialType = try await database.enum(TypeAPIModel.Material.getKey()).read()
            let colorType = try await database.enum(TypeAPIModel.Color.getKey()).read()
            
            try await database
                .schema(Product.schema)
                .id()
                .field(Product.Keys.brand, brandType, .required)
                .field(Product.Keys.goods, goodsType, .required)
                .field(Product.Keys.material, materialType, .required)
                .field(Product.Keys.color, colorType, .required)
                .field(Product.Keys.amount, .int, .required)
                .field(Product.Keys.count, .int, .required)
                .field(Product.Keys.note, .string)
                .field(Product.Keys.tradeID, .uuid, .required, .references(Trade.schema, .id, onDelete: .cascade))
                .field(Product.Keys.createdAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Product.schema)
                .delete()
        }
    }
}
