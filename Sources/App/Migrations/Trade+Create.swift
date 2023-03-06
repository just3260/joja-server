
import Foundation
import Fluent
import JOJACore

extension Trade {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let goodsType = try await database.enum(Trade.Keys.types.description)
                .case(TradeAPIModel.GoodsType.beret.rawValue)
                .case(TradeAPIModel.GoodsType.bucketHat.rawValue)
                .case(TradeAPIModel.GoodsType.flatBeret.rawValue)
                .case(TradeAPIModel.GoodsType.sun.rawValue)
                .case(TradeAPIModel.GoodsType.scarf.rawValue)
                .case(TradeAPIModel.GoodsType.ring.rawValue)
                .case(TradeAPIModel.GoodsType.bucketBag.rawValue)
                .case(TradeAPIModel.GoodsType.other.rawValue)
                .create()
            
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
