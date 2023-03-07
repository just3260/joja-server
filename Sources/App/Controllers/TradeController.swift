
import Vapor
import Fluent
import JOJACore

final class TradeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let tradeRoute = protectRoute.grouped(Endpoints.Trades.root.toPathComponents)
        
        tradeRoute.on(Endpoints.Trades.getSingle, use: getTrade)
        tradeRoute.on(Endpoints.Trades.create, use: create)
        tradeRoute.on(Endpoints.Trades.delete, use: delete)
    }
    
    
    // MARK: - Private Function
    
    fileprivate func getTrade(req: Request) async throws -> TradeAPIModel.Response {
        let tradeId = try req.requireUUID(parameterName: "tradeID")
        guard let trade = try await req.trades.find(id: tradeId) else {
            throw JojaError.modelNotFound(type: "Trade", id: tradeId.uuidString)
        }
        return try TradeAPIModel(trade: trade).asPublic()
    }
    
    fileprivate func create(req: Request) async throws -> TradeAPIModel.Response {
        let tradeModel = try req.content.decode(TradeAPIModel.Request.self)
        let productsModel = tradeModel.products
        let totalAmount = productsModel.map({$0.amount}).reduce(0, +)
        
        let trade = try tradeModel.createTrade(with: totalAmount)
        try await req.trades.create(trade)
        var products: [Product] = []
        
        if let tradeID = trade.id {
            try await withThrowingTaskGroup(of: Void.self, body: { taskGroup in
                for prod in productsModel {
                    let product = try prod.createProduct(with: tradeID)
                    taskGroup.addTask {
                        try await req.products.create(product)
                    }
                    products.append(product)
                }
                try await taskGroup.waitForAll()
            })
        }
        
        return try trade.makePublic(with: products.map({try $0.makePublic()}))
    }
    
    fileprivate func delete(req: Request) async throws -> HTTPStatus {
        let tradeId = try req.requireUUID(parameterName: "tradeID")
        try await req.trades.delete(id: tradeId)
        return .noContent
    }
}
