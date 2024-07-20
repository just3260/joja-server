
import Vapor
import Fluent
import JOJACore

final class MemberController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let memberRoute = protectRoute.grouped(Endpoints.Members.root.toPathComponents)
        
        memberRoute.grouped([PermissionCheck(permission: .createMember)]).on(Endpoints.Members.create, use: create)
        memberRoute.on(Endpoints.Members.getSingle, use: getMember)
        memberRoute.grouped([PermissionCheck(permission: .deleteMember)]).on(Endpoints.Members.delete, use: delete)
        memberRoute.on(Endpoints.Members.memberTrades, use: getMemberTrades)
        memberRoute.on(Endpoints.Members.getAll, use: getPage)
        memberRoute.grouped([PermissionCheck(permission: .editMember)]).on(Endpoints.Members.update, use: updateMember)
        memberRoute.on(Endpoints.Members.search, use: search)
        
        /** CRUD MEMBER
        protected.crud(CRUDMember.schema, model: CRUDMember.self) { routes, parentController in
            routes.get("hello") { _ in "Hello World" }
        }
         */
    }
    
    
    // MARK: - Private Function
    
    fileprivate func create(req: Request) async throws -> MemberAPIModel.Response.DTO {
        let model = try req.content.decode(MemberAPIModel.Request.self)
        let member = try model.createMember()
        
        // 判斷 member 是否有重複
        guard try await req.members.find(phone: member.phone) == nil else {
            throw JojaError.phoneAlreadyExists(phone: member.phone)
        }
        
        try await req.members.create(member)
        
        // 刪除 candidate list 內的資料
        if let candidateId = model.id {
            try await req.candidates.delete(id: candidateId)
        }
        
        return try member.makeNewPublic().toDTO()
    }
    
    fileprivate func delete(req: Request) async throws -> Responser<Connector>.ResponseDTO {
        let memberId = try req.requireUUID(parameterName: "memberID")
        try await req.members.delete(id: memberId)
        return Responser<Connector>.ResponseDTO(status: .success)
    }
    
    fileprivate func getMemberTrades(req: Request) async throws -> [TradeAPIModel.Response.DTO] {
        let memberId = try req.requireUUID(parameterName: "memberID")
        let trades = try await req.trades.findAll(by: memberId)
        
        return try await withThrowingTaskGroup(of: TradeAPIModel.Response.DTO.self,
                                               returning: [TradeAPIModel.Response.DTO].self,
                                               body: { taskGroup in
            for trade in trades {
                taskGroup.addTask {
//                    guard let products = try await req.products.findTrade(with: tradeId) else {
//                        throw JojaError.modelNotFound(type: "Product", id: tradeId.uuidString)
//                    }
//                    return try trade.makePublic(with: try products.map({try $0.makePublic()}))
                    return try trade.makePublic(with: []).toDTO()
                }
            }
            
            var tradeModels: [TradeAPIModel.Response.DTO] = []
            for try await model in taskGroup {
                tradeModels.append(model)
            }
            try await taskGroup.waitForAll()
            return tradeModels.sorted(by: {$0.data!.createdAt!.compare($1.data!.createdAt!) == .orderedDescending})
        })
    }
    
    fileprivate func getMember(req: Request) async throws -> MemberAPIModel.Response.DTO {
        let memberId = try req.requireUUID(parameterName: "memberID")
        guard let member = try await req.members.find(id: memberId) else {
            throw JojaError.modelNotFound(type: "Member", id: memberId.uuidString)
        }
        return try member.makeResponse().toDTO()
    }
    
    fileprivate func getAll(req: Request) async throws -> [MemberAPIModel.ListData.DTO] {
        try await req.members.all().map({ member in
            try member.makeList().toDTO()
        })
    }
    
    fileprivate func getPage(req: Request) async throws -> Page<MemberAPIModel.ListData>.DTO {
        let page = try req.query.decode(PageRequest.self)
        
        let pageData = try await req.members.page(with: page)
        var items: [MemberAPIModel.ListData] = []
        for item in pageData.items {
            items.append( try item.makeList())
        }
        return Page(items: items, metadata: pageData.metadata).toDTO()
    }
    
    fileprivate func updateMember(req: Request) async throws -> MemberAPIModel.Response.DTO {
        let model = try req.content.decode(MemberAPIModel.Request.self)
        let newMember = try model.createMember()
        let memberId = try req.requireUUID(parameterName: "memberID")
        
        try await req.members.update(newMember, in: memberId)
        
        // 暫時回傳
        guard let member = try await req.members.find(id: memberId) else {
            throw JojaError.modelNotFound(type: "Member", id: memberId.uuidString)
        }
        return try member.makeResponse().toDTO()
    }
    
    fileprivate func search(req: Request) async throws -> Page<MemberAPIModel.ListData>.DTO {
        let model = try req.query.decode(SearchAPIModel<SearchType.Member>.self)
        let page = try req.query.decode(PageRequest.self)
        
        let pageData = try await req.members.search(with: page, and: model)
        var items: [MemberAPIModel.ListData] = []
        for item in pageData.items {
            items.append( try item.makeList())
        }
        return Page(items: items, metadata: pageData.metadata).toDTO()
    }
    
}
