
import Vapor
import Fluent
import JOJACore

final class ProductController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protectRoute = routes.grouped([APIKeyCheck(), Token.authenticator(), AuthCheck()])
        let productRoute = protectRoute.grouped(Endpoints.Products.root.toPathComponents)
        
        productRoute.on(Endpoints.Products.getProduct, use: getProduct)
//        productRoute.on(Endpoints.Products.create, use: create)
//        productRoute.on(Endpoints.Products.delete, use: delete)
    }
    
    
    // MARK: - Private Function
    
    fileprivate func getProduct(req: Request) async throws -> ProductAPIModel.Response.DTO {
        let productId = try req.requireUUID(parameterName: "productID")
        guard let product = try await req.products.find(id: productId) else {
            throw JojaError.modelNotFound(type: "Product", id: productId.uuidString)
        }
        return try ProductAPIModel(product: product).asPublic().toDTO()
    }
    
//    fileprivate func create(req: Request) async throws -> ProductAPIModel.Response {
//        let model = try req.content.decode(ProductAPIModel.Request.self)
//        let product = try model.createProduct()
//        try await req.products.create(product)
//        return try product.makePublic()
//    }
    
//    fileprivate func delete(req: Request) async throws -> Responser<Connector>.ResponseDTO {
//        let productId = try req.requireUUID(parameterName: "productIdID")
//        try await req.products.delete(id: productId)
//        return Responser<Connector>.ResponseDTO(status: .success)
//    }
}
