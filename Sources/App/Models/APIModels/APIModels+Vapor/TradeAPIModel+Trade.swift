
import Vapor
import JOJACore
import Fluent

extension Trade {
    func makePublic(with products: [ProductAPIModel.Response]) throws -> TradeAPIModel.Response {
        TradeAPIModel.Response(id: try self.requireID(),
                               products: products,
                               amount: self.amount,
                               note: self.note,
                               buyerID: self.$buyer.id,
                               createdAt: self.createdAt
        )
    }
}

extension TradeAPIModel: Content {
    func asPublic() throws -> TradeAPIModel.Response {
        TradeAPIModel.Response(
            id: id,
            products: try products.map({try $0.asPublic()}),
            amount: amount,
            note: note,
            buyerID: buyerID,
            createdAt: createdAt
        )
    }
}

extension TradeAPIModel {
    init(trade: Trade) throws {
        try self.init(
            id: trade.requireID(),
            products: trade.products.map({try ProductAPIModel(product: $0)}),
            amount: trade.amount,
            note: trade.note,
            buyerID: trade.$buyer.id,
            createdAt: trade.createdAt ?? Date()
        )
    }
}

extension TradeAPIModel.Request {
    func createTrade(with amount: Int) throws -> Trade {
        Trade(amount: amount,
              note: note,
              buyerID: buyerID,
              createdAt: Date()
        )
    }
}

extension TradeAPIModel.Response: Content {}
