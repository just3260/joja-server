
import Vapor
import JOJACore
import Fluent

extension TradeAPIModel: Content {
    func asPublic() throws -> TradeAPIModel.Response {
        TradeAPIModel.Response(
            id: id,
            goods: goods,
            types: types,
            amount: amount,
            note: note,
            buyer: buyer,
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
            buyer: MemberAPIModel(member: trade.buyer),
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
