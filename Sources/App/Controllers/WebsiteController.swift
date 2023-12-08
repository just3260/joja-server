
import Vapor
import JOJACore

struct WebsiteController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
//        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
//        let protectRoute = routes.grouped([APIKeyCheck()])
//        let webRoute = protectRoute.grouped(Endpoints.Candidates.root.toPathComponents)
        
        routes.get("hello", use: getHello)
        routes.get("newMember", use: createNewMember)
        routes.get("index", use: getIndex)
        routes.post("index", use: sendForm)
    }
    
    
//    app.get("hello") { req async throws -> View in
//        return try await req.view.render("hello", ["name": "Leaf"])
//    }
    
    
    // MARK: - Private Function
    
    fileprivate func getHello(req: Request) async throws -> View {
        return try await req.view.render("hello", ["name": "Leaf"])
    }
    
    
    fileprivate func createNewMember(req: Request) async throws -> View {
        
        let context = MemberContext(title: "Member", user: "JOJA")
        return try await req.view.render("newMember", context)
    }
    
    
    fileprivate func getIndex(req: Request) async throws -> View {
        
        let context = MemberContext(title: "Member", user: "JOJA")
        return try await req.view.render("index", context)
    }
    
    
    fileprivate func sendForm(req: Request) async throws -> String {
        do {
            let formData = try req.content.decode(CandidateAPIModel.Request.self)
            let candidate = try formData.createCandidate()
            try await req.candidates.create(candidate)
            return "收到了來自「\(formData.name)」的表單提交！"
        } catch {
            print(error)
            return error.localizedDescription
        }
    }
    
    
    /*
    func indexHandler(_ req: Request) throws -> EventLoopFuture<View> {
        Acronym.query(on: req.db).all().flatMap { acronyms in
            let acronymsData = acronyms.isEmpty ? nil : acronyms
            let context = IndexContext(title: "Home page", acronyms: acronymsData)
            return req.view.render("index", context)
        }
    }
    
    func acronymHandler(_ req: Request) throws -> EventLoopFuture<View> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
            acronym.$user.get(on: req.db).flatMap { user in
                let context = AcronymContext(title: acronym.short, acronym: acronym, user: user)
                return req.view.render("acronym", context)
            }
        }
    }
    */
    
    
}


struct MemberContext: Encodable {
    let title: String
    let user: String
}


/*
struct AcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let user: User
}
*/
