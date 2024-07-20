
import Vapor
import Fluent
import JOJACore

final class FabricController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let fabricRoute = protectRoute.grouped(Endpoints.Fabrics.root.toPathComponents)
        
        fabricRoute.on(Endpoints.Fabrics.getSingle, use: getFabric)
        fabricRoute.on(Endpoints.Fabrics.getAll, use: getPage)
        fabricRoute.grouped([PermissionCheck(permission: .createFabric)]).on(Endpoints.Fabrics.create, use: create)
        fabricRoute.grouped([PermissionCheck(permission: .deleteFabric)]).on(Endpoints.Fabrics.delete, use: delete)
        fabricRoute.grouped([PermissionCheck(permission: .deleteFabric)]).on(Endpoints.Fabrics.deleteImage, use: deleteImage)
//        fabricRoute.on(Endpoints.Fabrics.getList, use: getFabricList)
        
        fabricRoute.grouped([PermissionCheck(permission: .createFabric)]).on(Endpoints.Fabrics.addTag, use: addTag)
        fabricRoute.grouped([PermissionCheck(permission: .createFabric)]).on(Endpoints.Fabrics.uploadImage, use: uploadImage)
    }
    
    
    // MARK: - Private Function
    
    fileprivate func getPage(req: Request) async throws -> Page<FabricAPIModel.ListData>.DTO {
        let page = try req.query.decode(PageRequest.self)
        
        let pageData = try await req.fabrics.page(with: page)
        var items: [FabricAPIModel.ListData] = []
        for item in pageData.items {
            items.append( try item.makeList())
        }
        return Page(items: items, metadata: pageData.metadata).toDTO()
    }
    
    fileprivate func getFabric(req: Request) async throws -> FabricAPIModel.Response.DTO {
        let fabricId = try req.requireUUID(parameterName: "fabricID")
        guard let fabric = try await req.fabrics.find(id: fabricId) else {
            throw JojaError.modelNotFound(type: "Fabric", id: fabricId.uuidString)
        }
        
        try await fabric.$tags.load(on: req.db)
        try await fabric.$storages.load(on: req.db)
        try await fabric.$storages.$pivots.load(on: req.db)
        
        return try fabric.makePublic().toDTO()
    }
    
    fileprivate func create(req: Request) async throws -> FabricAPIModel.Response.DTO {
        let model = try req.content.decode(FabricAPIModel.Request.self)
        let fabric = try model.createFabric()
        let count = try await req.fabrics.findAll(in: fabric.component.getSerialHeader()).count
        fabric.sn += "-" + String(format: "%03d", count + 1)
        
        try await req.fabrics.create(fabric)
        
        if let storage = try await req.storages.findStorage(name: model.location.getName()) {
            try await req.fabrics.store(fabirc: fabric, in: storage, with: model.buy)
        }
        
        try await fabric.$tags.load(on: req.db)
        try await fabric.$storages.load(on: req.db)
        try await fabric.$storages.$pivots.load(on: req.db)
        
        return try fabric.makePublic().toDTO()
    }
    
    /*
    fileprivate func createUpload(req: Request) async throws -> FabricAPIModel.Response {
        let uploadPath = req.application.directory.publicDirectory + "Uploads/Fabric/"
//        let component = try req.content.decode(FabricAPIModel.Component.self)
        let model = try req.content.decode(FabricAPIModel.Request.self)
        let files = try req.content.decode(ImageFile.self)
        
        let fabric = try model.createFabric()
        let count = try await req.fabrics.findAll(in: fabric.component.getSerialHeader()).count
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
     */
    
    fileprivate func delete(req: Request) async throws -> Responser<Connector>.ResponseDTO {
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
        return Responser<Connector>.ResponseDTO(status: .success)
    }
    
    fileprivate func addTag(req: Request) async throws -> FabricAPIModel.Response.DTO {
        let fabricId = try req.requireUUID(parameterName: "fabricID")
        let model = try req.content.decode(FabricAPIModel.TagRequest.self)
        
        guard let fabric = try await req.fabrics.find(id: fabricId) else {
            throw JojaError.modelNotFound(type: "Fabric", id: fabricId.uuidString)
        }
        
        try await fabric.$tags.load(on: req.db)
        let currentTagNames = fabric.tags.map({$0.name})
        let pendingTagNames = model.tags.filter({!currentTagNames.contains($0)})
        
        return try await withThrowingTaskGroup(of: Tag.self,
                                               returning: FabricAPIModel.Response.DTO.self,
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
            try await fabric.$storages.load(on: req.db)
            try await fabric.$storages.$pivots.load(on: req.db)
            
            return try fabric.makePublic().toDTO()
        })
    }
    
    fileprivate func uploadImage(req: Request) async throws -> String {
        let fabricId = try req.requireUUID(parameterName: "fabricID")
        guard let fabric = try await req.fabrics.find(id: fabricId) else {
            throw JojaError.modelNotFound(type: "Fabric", id: fabricId.uuidString)
        }
        
        let uploadPath = req.application.directory.publicDirectory + "Uploads/Fabric/"
        let file = try req.content.decode(File.self)
        let fileName = file.filename.isEmpty ? "\(fabric.sn)-\(fabric.images.count + 1).\(file.contentType?.subType ?? "jpg")" : file.filename
        
        try await req.fileio.writeFile(file.data, at: uploadPath + fileName)
        
        if file.filename.isEmpty {
            var images = fabric.images
            images.append(uploadPath + fileName)
            try await req.fabrics.updateImage(with: images, in: fabricId)
        }
        return uploadPath + fileName
    }
    
    fileprivate func deleteImage(req: Request) async throws -> Responser<Connector>.ResponseDTO {
        let fabricId = try req.requireUUID(parameterName: "fabricID")
        guard let fabric = try await req.fabrics.find(id: fabricId) else {
            throw JojaError.modelNotFound(type: "Fabric", id: fabricId.uuidString)
        }
        
        guard let index = req.parameters.get("index") else {
            throw JojaError.missingParameter(name: "index")
        }
        
        let uploadPath = req.application.directory.publicDirectory + "Uploads/Fabric/"
        let fileName = "\(fabric.sn)-\(index).jpg"
        
        let path = uploadPath + fileName
        let manager = FileManager.default
        
        if manager.fileExists(atPath: path) {
            if let url: URL = .init(string:"file://" + path) {
                try manager.removeItem(at: url)
            }
            
            var images = fabric.images
            if images.contains(path) {
                images.removeAll(where: {$0 == path})
                try await req.fabrics.updateImage(with: images, in: fabricId)
            }
        }
        
        return Responser<Connector>.ResponseDTO(status: .success)
    }
}
