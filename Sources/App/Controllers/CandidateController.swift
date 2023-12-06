
import Vapor
import Fluent
import JOJACore

final class CandidateController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let candidateRoute = protectRoute.grouped(Endpoints.Candidates.root.toPathComponents)
        
        candidateRoute.on(Endpoints.Candidates.create, use: create)
        candidateRoute.on(Endpoints.Candidates.delete, use: delete)
        candidateRoute.on(Endpoints.Candidates.getSingle, use: getCandidate)
        candidateRoute.on(Endpoints.Candidates.getAll, use: getAll)
        
        /** CRUD MEMBER
        protected.crud(CRUDMember.schema, model: CRUDMember.self) { routes, parentController in
            routes.get("hello") { _ in "Hello World" }
        }
         */
    }
    
    
    // MARK: - Private Function
    
    fileprivate func create(req: Request) async throws -> CandidateAPIModel.Response {
        let model = try req.content.decode(CandidateAPIModel.Request.self)
        let candidate = try model.createCandidate()
        try await req.candidates.create(candidate)
        return try candidate.makeNewPublic()
//        return try MemberAPIModel(member: member).asPublic()
    }
    
    fileprivate func delete(req: Request) async throws -> HTTPStatus {
        let candidateId = try req.requireUUID(parameterName: "candidateID")
        try await req.candidates.delete(id: candidateId)
        return .noContent
    }
    
    fileprivate func getCandidate(req: Request) async throws -> CandidateAPIModel.Response {
        let candidateId = try req.requireUUID(parameterName: "candidateID")
        guard let candidate = try await req.candidates.find(id: candidateId) else {
            throw JojaError.modelNotFound(type: "Candidates", id: candidateId.uuidString)
        }
        return try candidate.makeResponse()
    }
    
    fileprivate func getAll(req: Request) async throws -> [CandidateAPIModel.ListData] {
        try await req.candidates.all().map({ candidate in
            try candidate.makeList()
        })
    }
}