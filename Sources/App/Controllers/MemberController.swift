
import Vapor
import Fluent
import JOJACore

final class MemberController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let memberRoute = protectRoute.grouped(Endpoints.Members.root.toPathComponents)
        
        memberRoute.on(Endpoints.Members.create, use: create)
        memberRoute.on(Endpoints.Members.delete, use: delete)
        memberRoute.on(Endpoints.Members.getSingle, use: getMember)
        memberRoute.on(Endpoints.Members.getAll, use: getAll)
        
        /** CRUD MEMBER
        protected.crud(CRUDMember.schema, model: CRUDMember.self) { routes, parentController in
            routes.get("hello") { _ in "Hello World" }
        }
         */
    }
    
    
    // MARK: - Private Function
    
    fileprivate func create(req: Request) async throws -> MemberAPIModel.Response {
        let model = try req.content.decode(MemberAPIModel.Request.self)
        let member = try model.createMember()
        try await req.members.create(member)
        
        // 刪除 candidate list 內的資料
        if let candidateId = model.id {
            try await req.candidates.delete(id: candidateId)
        }
        
        return try member.makeNewPublic()
    }
    
    fileprivate func delete(req: Request) async throws -> HTTPStatus {
        let memberId = try req.requireUUID(parameterName: "memberID")
        try await req.members.delete(id: memberId)
        return .noContent
    }
    
    fileprivate func getMember(req: Request) async throws -> MemberAPIModel.Response {
        let memberId = try req.requireUUID(parameterName: "memberID")
        guard let member = try await req.members.find(id: memberId) else {
            throw JojaError.modelNotFound(type: "Member", id: memberId.uuidString)
        }
        return try member.makeResponse()
    }
    
    fileprivate func getAll(req: Request) async throws -> [MemberAPIModel.ListData] {
        try await req.members.all().map({ member in
            try member.makeList()
        })
    }
}
