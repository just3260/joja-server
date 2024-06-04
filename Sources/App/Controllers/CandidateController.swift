
import Vapor
import Fluent
import JOJACore

final class CandidateController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck()])
        let createRoute = protectRoute.grouped(Endpoints.Candidates.root.toPathComponents)
        createRoute.on(Endpoints.Candidates.create, use: create)
        
        let candidateRoute = createRoute.grouped([Token.authenticator(), AuthCheck()])
        candidateRoute.grouped([PermissionCheck(permission: .deleteCandidate)]).on(Endpoints.Candidates.delete, use: delete)
        candidateRoute.on(Endpoints.Candidates.getSingle, use: getCandidate)
        candidateRoute.on(Endpoints.Candidates.getAll, use: getPage)
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
    
    fileprivate func getPage(req: Request) async throws -> Page<CandidateAPIModel.ListData> {
        let pageData = try await req.candidates.page(with: req)
        var items: [CandidateAPIModel.ListData] = []
        for item in pageData.items {
            items.append( try item.makeList())
        }
        return Page(items: items, metadata: pageData.metadata)
    }
    
    /** 直接取得所有列表
    fileprivate func getAll(req: Request) async throws -> [CandidateAPIModel.ListData] {
        try await req.candidates.all().map({ candidate in
            try candidate.makeList()
        })
    }
     */
}
