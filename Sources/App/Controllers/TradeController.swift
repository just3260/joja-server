
import Vapor
import Fluent
import JOJACore

final class TradeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let tradeRoute = protectRoute.grouped(Endpoints.Trades.root.toPathComponents)
        
        tradeRoute.on(Endpoints.Trades.create, use: create)
        tradeRoute.on(Endpoints.Trades.delete, use: delete)
    }
    
    fileprivate func create(req: Request) async throws -> TradeAPIModel.Response {
        let model = try req.content.decode(TradeAPIModel.Request.self)
        let trade = try model.createTrade()
        try await req.trades.create(trade)
        return try TradeAPIModel.init(trade: trade).asPublic()
    }
    
    fileprivate func delete(req: Request) async throws -> HTTPStatus {
        let tradeId = try req.requireUUID(parameterName: "tradeID")
        try await req.trades.delete(id: tradeId)
        return .noContent
    }
}
