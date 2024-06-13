
import Vapor
import Fluent
import JOJACore

final class FabricController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let fabricRoute = protectRoute.grouped(Endpoints.Fabrics.root.toPathComponents)
        
        fabricRoute.on(Endpoints.Fabrics.getSingle, use: getFabric)
        fabricRoute.grouped([PermissionCheck(permission: .createFabric)]).on(Endpoints.Fabrics.create, use: createUpload)
        fabricRoute.grouped([PermissionCheck(permission: .deleteFabric)]).on(Endpoints.Fabrics.delete, use: delete)
//        fabricRoute.on(Endpoints.Fabrics.getList, use: getFabricList)
        
        fabricRoute.grouped([PermissionCheck(permission: .createFabric)]).on(Endpoints.Fabrics.addTag, use: addTag)
    }
    
    
    // MARK: - Private Function
    
    fileprivate func getFabric(req: Request) async throws -> FabricAPIModel.Response {
        let fabricId = try req.requireUUID(parameterName: "fabricID")
        guard let fabric = try await req.fabrics.find(id: fabricId) else {
            throw JojaError.modelNotFound(type: "Fabric", id: fabricId.uuidString)
        }
        try await fabric.$tags.load(on: req.db)
        return try fabric.makePublic()
    }
    
    /*
    fileprivate func create(req: Request) async throws -> FabricAPIModel.Response {
        let model = try req.content.decode(FabricAPIModel.Request.self)
        let fabric = try model.createFabric()
        
        try await req.fabrics.create(fabric)
        try await fabric.$tags.load(on: req.db)
        return try fabric.makePublic()
    }
     */
    
    fileprivate func createUpload(req: Request) async throws -> FabricAPIModel.Response {
        let uploadPath = req.application.directory.publicDirectory + "Uploads/Fabric/"
        let model = try req.content.decode(FabricAPIModel.Request.self)
        let files = try req.content.decode(ImageFile.self)
        
        let fabric = try model.createFabric()
        let count = try await req.fabrics.findAll(in: fabric.getSerialHeader()).count
        fabric.sn += "-" + String(format: "%03d", count + 1)
        
        return try await withThrowingTaskGroup(of: String.self,
                                               returning: FabricAPIModel.Response.self,
                                               body: { taskGroup in
            for (index, file) in files.images.enumerated() {
                taskGroup.addTask {
                    let fileName = "\(fabric.sn)-\(index).\(file.contentType?.subType ?? "jpg")"
                    try await req.fileio.writeFile(file.data, at: uploadPath + fileName)
                    return uploadPath + fileName
                }
            }
            
            var fielNames: [String] = []
            for try await name in taskGroup {
                fielNames.append(name)
            }
            try await taskGroup.waitForAll()
            fabric.images = fielNames
            
            try await req.fabrics.create(fabric)
            try await fabric.$tags.load(on: req.db)
            return try fabric.makePublic()
        })
    }
    
    fileprivate func delete(req: Request) async throws -> HTTPStatus {
        let fabricId = try req.requireUUID(parameterName: "fabricID")
        
        guard let fabric = try await req.fabrics.find(id: fabricId) else {
            throw JojaError.modelNotFound(type: "Fabric", id: fabricId.uuidString)
        }
        
        do {
            try fabric.images.forEach { filePath in
                if filePath.isNotEmpty {
                    let manager = FileManager.default
                    
                    if manager.fileExists(atPath: filePath ) {
                        if let url: URL = .init(string:"file://" + filePath) {
                            try manager.removeItem(at: url)
                        }
                    }
                }
            }
        } catch(let error)  {
            throw JojaError.other(description: error.localizedDescription)
        }
        
        try await req.fabrics.delete(id: fabricId)
        return .noContent
    }
    
    fileprivate func addTag(req: Request) async throws -> FabricAPIModel.Response {
        let fabricId = try req.requireUUID(parameterName: "fabricID")
        let model = try req.content.decode(FabricAPIModel.TagRequest.self)
        
        guard let fabric = try await req.fabrics.find(id: fabricId) else {
            throw JojaError.modelNotFound(type: "Fabric", id: fabricId.uuidString)
        }
        
        try await fabric.$tags.load(on: req.db)
        let currentTagNames = fabric.tags.map({$0.name})
        let pendingTagNames = model.tags.filter({!currentTagNames.contains($0)})
        
        return try await withThrowingTaskGroup(of: Tag.self,
                                               returning: FabricAPIModel.Response.self,
                                               body: { taskGroup in
            for tagName in pendingTagNames {
                taskGroup.addTask {
                    if let findTag = try await req.tags.findTag(name: tagName) {
                        return findTag
                    }
                    let newTag = try TagAPIModel.Request(name: tagName, description: nil).createTag()
                    try await req.tags.create(newTag)
                    return newTag
                }
            }
            for try await tag in taskGroup {
                try await req.fabrics.addTag(in: fabric, with: tag)
            }
            try await taskGroup.waitForAll()
            
            guard let fabric = try await req.fabrics.find(id: fabricId) else {
                throw JojaError.modelNotFound(type: "Fabric", id: fabricId.uuidString)
            }
            
            try await fabric.$tags.load(on: req.db)
            return try fabric.makePublic()
        })
    }
}
