
import Foundation
import Fluent
import JOJACore

extension Trade {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let goodsType = try await database.enum(TypeAPIModel.Goods.getKey()).read()
            
            try await database
                .schema(Trade.schema)
                .id()
                .field(Trade.Keys.goods, .string, .required)
//                .field(Trade.Keys.types, .array(of: .int), .required)
                .field(Trade.Keys.types, goodsType, .required)
                .field(Trade.Keys.amount, .int, .required)
                .field(Trade.Keys.note, .string)
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
