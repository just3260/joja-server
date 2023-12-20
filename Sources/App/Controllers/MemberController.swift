
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
        memberRoute.on(Endpoints.Members.update, use: updateMember)
        
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
    
    fileprivate func updateMember(req: Request) async throws -> MemberAPIModel.Response {
        let model = try req.content.decode(MemberAPIModel.Request.self)
        let newMember = try model.createMember()
        let memberId = try req.requireUUID(parameterName: "memberID")
        
        try await req.members.update(newMember, in: memberId)
        
        // 暫時回傳
        guard let member = try await req.members.find(id: memberId) else {
            throw JojaError.modelNotFound(type: "Member", id: memberId.uuidString)
        }
        return try member.makeResponse()
    }
    
//    func updateExampleObject(req: Request) async throws -> HTTPStatus {
//        let exampleObject = try req.content.decode(ExampleObject.self)
//        
//        guard let existingExampleObject = try await ExampleObject.find(exampleObject.id, on: req.db) else {
//            // throw a "not found" error if we try to update something that isn't there
//            throw Abort(.notFound)
//        }
//        
//        // update the existing object with the one being passed in from the API
//        existingExampleObject.id = exampleObject.id
//        existingExampleObject.name = exampleObject.name
//        existingExampleObject.imageLink = exampleObject.imageLink
//        
//        // store the newly updated object to the database
//        try await existingExampleObject.save(on: req.db)
//        
//        return .ok
//    }
    
}
