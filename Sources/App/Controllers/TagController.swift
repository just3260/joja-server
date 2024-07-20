
import Vapor
import Fluent
import JOJACore

final class TagController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let tagRoute = protectRoute.grouped(Endpoints.Tags.root.toPathComponents)
        
        tagRoute.on(Endpoints.Tags.getSingle, use: getTag)
        tagRoute.on(Endpoints.Tags.getList, use: getTagList)
        tagRoute.grouped([PermissionCheck(permission: .createTag)]).on(Endpoints.Tags.create, use: create)
        tagRoute.grouped([PermissionCheck(permission: .deleteTag)]).on(Endpoints.Tags.delete, use: delete)
    }
    
    // MARK: - Private Function
    
    fileprivate func getTag(req: Request) async throws -> TagAPIModel.Response.DTO {
        let tagId = try req.requireUUID(parameterName: "tagID")
        guard let tag = try await req.tags.find(id: tagId) else {
            throw JojaError.modelNotFound(type: "Tag", id: tagId.uuidString)
        }
        return try tag.makePublic().toDTO()
    }
    
    fileprivate func getTagList(req: Request) async throws -> [TagAPIModel.Response.DTO] {
        return try await req.tags.findAll().map({try $0.makePublic().toDTO()})
    }
    
    fileprivate func create(req: Request) async throws -> TagAPIModel.Response.DTO {
        let model = try req.content.decode(TagAPIModel.Request.self)
        let tag = try model.createTag()
        
        try await req.tags.create(tag)
        return try tag.makePublic().toDTO()
    }
    
    fileprivate func delete(req: Request) async throws -> Responser<Connector>.ResponseDTO {
        let tagId = try req.requireUUID(parameterName: "tagID")
        
        guard let tag = try await req.tags.find(id: tagId) else {
            throw JojaError.modelNotFound(type: "Tag", id: tagId.uuidString)
        }
        try await req.tags.delete(id: tagId)
        return Responser<Connector>.ResponseDTO(status: .success)
    }
}
