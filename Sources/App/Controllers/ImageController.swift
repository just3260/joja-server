
import Vapor
import Fluent
import JOJACore

final class ImageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
//        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let imageRoute = routes.grouped(Endpoints.Images.root.toPathComponents)
        
        imageRoute.on(Endpoints.Images.fabric, use: getFabricImage)
    }
    
    
    // MARK: - Private Function
    
    fileprivate func getFabricImage(req: Request) async throws -> Response {
        guard let imageName = req.parameters.get("imageName") else {
            throw JojaError.missingParameter(name: "imageName")
        }
        let imagePath = req.application.directory.publicDirectory + "Uploads/Fabric/" + imageName
        return req.fileio.streamFile(at: imagePath)
    }
    
}
