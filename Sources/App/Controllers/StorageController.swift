
import Vapor
import Fluent
import JOJACore

final class StorageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let storageRoute = protectRoute.grouped(Endpoints.Storages.root.toPathComponents)
        
        storageRoute.on(Endpoints.Storages.getSingle, use: getStorage)
        storageRoute.on(Endpoints.Storages.getList, use: getStorageList)
        storageRoute.on(Endpoints.Storages.create, use: create)
        storageRoute.on(Endpoints.Storages.delete, use: delete)
    }
    
    // MARK: - Private Function
    
    fileprivate func getStorage(req: Request) async throws -> StorageAPIModel.Response.DTO {
        let storageId = try req.requireUUID(parameterName: "storageID")
        guard let storage = try await req.storages.find(id: storageId) else {
            throw JojaError.modelNotFound(type: "Storage", id: storageId.uuidString)
        }
        return try storage.makePublic().toDTO()
    }
    
    fileprivate func getStorageList(req: Request) async throws -> [StorageAPIModel.Response.DTO] {
        return try await req.storages.findAll().map({try $0.makePublic().toDTO()})
    }
    
    fileprivate func create(req: Request) async throws -> StorageAPIModel.Response.DTO {
        let model = try req.content.decode(StorageAPIModel.Request.self)
        let storage = try model.createStorage()
        
        try await req.storages.create(storage)
        return try storage.makePublic().toDTO()
    }
    
    fileprivate func delete(req: Request) async throws -> Responser<Connector>.ResponseDTO {
        let storageId = try req.requireUUID(parameterName: "storageID")
        
        guard let storage = try await req.storages.find(id: storageId) else {
            throw JojaError.modelNotFound(type: "Storage", id: storageId.uuidString)
        }
        try await req.storages.delete(id: storageId)
        return Responser<Connector>.ResponseDTO(status: .success)
    }
}
