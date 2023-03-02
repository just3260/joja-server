
import Vapor
import JOJACore
import Fluent

extension Trade {
    func makePublic() throws -> TradeAPIModel.Response {
        TradeAPIModel.Response(id: try self.requireID(),
                               goods: self.goods,
                               types: self.types,
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
            goods: goods,
            types: types,
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
            goods: trade.goods,
            types: trade.types,
            amount: trade.amount,
            note: trade.note,
            buyerID: trade.$buyer.id,
            createdAt: trade.createdAt ?? Date()
        )
    }
}

extension TradeAPIModel.Request {
    func createTrade() throws -> Trade {
        Trade(
            goods: goods,
            types: types,
            amount: amount,
            note: note,
            buyerID: buyerID,
            createdAt: Date()
        )
    }
}

extension TradeAPIModel.Response: Content {}