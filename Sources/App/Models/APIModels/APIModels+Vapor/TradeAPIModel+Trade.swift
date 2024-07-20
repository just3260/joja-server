
import Vapor
import JOJACore
import Fluent

extension Trade {
    func makePublic(with products: [ProductAPIModel.Response]) throws -> TradeAPIModel.Response {
        TradeAPIModel.Response(id: try self.requireID(),
                               products: products,
                               amount: self.amount,
                               note: self.note,
                               description: self.description,
                               buyerID: self.$buyer.id,
                               createdAt: self.createdAt
        )
    }
    
    func makeSimple() throws -> TradeAPIModel.SimpleTrade {
        TradeAPIModel.SimpleTrade(id: try self.requireID(),
                                  amount: self.amount,
                                  note: self.note,
                                  description: self.description,
                                  buyerID: self.$buyer.id,
                                  createdAt: self.createdAt
        )
    }
}

extension TradeAPIModel: Content, Connectable {
    func asPublic() throws -> TradeAPIModel.Response {
        TradeAPIModel.Response(
            id: id,
            products: try products.map({try $0.asPublic()}),
            amount: amount,
            note: note,
            description: description,
            buyerID: buyerID,
            createdAt: createdAt
        )
    }
    
    func asSimple() throws -> TradeAPIModel.SimpleTrade {
        TradeAPIModel.SimpleTrade(id: id,
                                  amount: amount,
                                  note: note,
                                  description: description,
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
            note: trade.note.nilIfEmpty,
            description: trade.description,
            buyerID: trade.$buyer.id,
            createdAt: trade.createdAt ?? Date()
        )
    }
}

extension TradeAPIModel.Request {
    func createTrade(with amount: Int) throws -> Trade {
        
        // get product description
//        let products = self.products.prefix(3)
        var desc = ""
        try self.products.forEach { prod in
            if prod.amount < 0 || (prod.note ?? "").isEmpty {
                throw JojaError.valueEmpty(field: "note")
            }
            desc += prod.brand.getName() + " " + (prod.note ?? "") + " $\(prod.amount)\n"
        }
        desc.removeLast(1)
        
        return Trade(amount: amount,
                     note: note,
                     description: desc,
                     buyerID: buyerID,
                     createdAt: Date()
        )
    }
}

extension TradeAPIModel.Response: Content, Connectable {}
