
import Vapor
import Fluent
import JOJACore

final class MemberController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let memberRoute = protectRoute.grouped(Endpoints.Members.root.toPathComponents)
        
        memberRoute.on(Endpoints.Members.create, use: create)
        memberRoute.on(Endpoints.Members.delete, use: delete)
        
        
        /** CRUD MEMBER
        protected.crud(CRUDMember.schema, model: CRUDMember.self) { routes, parentController in
            routes.get("hello") { _ in "Hello World" }
        }
         */
    }
    
    fileprivate func create(req: Request) async throws -> MemberAPIModel.Response {
        let model = try req.content.decode(MemberAPIModel.Request.self)
        let member = try model.createMember()
        try await req.members.create(member)
        return try MemberAPIModel.init(member: member).asPublic()
    }
    
    fileprivate func delete(req: Request) async throws -> HTTPStatus {
        let memberId = try req.requireUUID(parameterName: "memberID")
        try await req.members.delete(id: memberId)
        return .noContent
    }
}
