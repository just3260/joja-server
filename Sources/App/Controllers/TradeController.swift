
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
        tradeRoute.on(Endpoints.Trades.getList, use: getTradeList)
    }
    
    
    // MARK: - Private Function
    
    fileprivate func getTrade(req: Request) async throws -> TradeAPIModel.Response {
        let tradeId = try req.requireUUID(parameterName: "tradeID")
        guard let trade = try await req.trades.find(id: tradeId) else {
            throw JojaError.modelNotFound(type: "Trade", id: tradeId.uuidString)
        }
        
        guard let products = try await req.products.findTrade(with: tradeId) else {
            throw JojaError.modelNotFound(type: "Product", id: tradeId.uuidString)
        }
        
        return try trade.makePublic(with: try products.map({try $0.makePublic()}))
    }
    
    fileprivate func create(req: Request) async throws -> TradeAPIModel.Response {
        let tradeModel = try req.content.decode(TradeAPIModel.Request.self)
        // totol amount from products
        let totalAmount = tradeModel.products.map({$0.amount}).reduce(0, +)
        
        let trade = try tradeModel.createTrade(with: totalAmount)
        try await req.trades.create(trade)
        var products: [Product] = []
        
//        if let tradeID = trade.id { // get correct tradeID
//            try await withThrowingTaskGroup(of: Void.self, body: { taskGroup in
//                for prod in tradeModel.products {
//                    let product = try prod.createProduct(with: tradeID)
//                    taskGroup.addTask {
//                        try await req.products.create(product)
//                    }
//                    products.append(product)
//                }
//                try await taskGroup.waitForAll()
//            })
//        }
        
        // add amount to member
        try await req.members.gainAmount(with: totalAmount, in: tradeModel.buyerID)
        
        return try trade.makePublic(with: products.map({try $0.makePublic()}))
    }
    
    // TODO: - finish it
    fileprivate func delete(req: Request) async throws -> HTTPStatus {
        let tradeId = try req.requireUUID(parameterName: "tradeID")
        try await req.trades.delete(id: tradeId)
        return .noContent
    }
    
    fileprivate func getTradeList(req: Request) async throws -> [TradeAPIModel.Response] {
        let tradeIDs = try req.content.decode([UUID].self)
        
        return try await withThrowingTaskGroup(of: TradeAPIModel.Response.self,
                                               returning: [TradeAPIModel.Response].self,
                                               body: { taskGroup in
            for tradeID in tradeIDs {
                taskGroup.addTask {
                    guard let trade = try await req.trades.find(id: tradeID) else {
                        throw JojaError.modelNotFound(type: "Trade", id: tradeID.uuidString)
                    }
                    guard let products = try await req.products.findTrade(with: tradeID) else {
                        throw JojaError.modelNotFound(type: "Product", id: tradeID.uuidString)
                    }
                    return try trade.makePublic(with: try products.map({try $0.makePublic()}))
                }
            }
            
            var tradeModels: [TradeAPIModel.Response] = []
            for try await model in taskGroup {
                tradeModels.append(model)
            }
            try await taskGroup.waitForAll()
            return tradeModels.sorted(by: {$0.createdAt!.compare($1.createdAt!) == .orderedDescending})
        })
    }
    
}
