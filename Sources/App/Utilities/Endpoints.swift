
import Vapor

public struct Endpoints {
    public struct RouteDefinition {
        public enum HTTPMethod: String {
            case GET
            case POST
            case PUT
            case PATCH
            case DELETE
        }
        public let root: [String]
        public let method: RouteDefinition.HTTPMethod
        public let path: [String]
        
        var httpMethod: Vapor.HTTPMethod { .init(rawValue: method.rawValue) }
        var rootComponents: [Vapor.PathComponent] { root.toPathComponents }
        var pathComponents: [Vapor.PathComponent] { path.toPathComponents }
    }
}

extension Array where Element == String {
    var toPathComponents: [PathComponent] { self.map(PathComponent.init) }
}

extension RoutesBuilder {
    @discardableResult
    public func on<Response>(
        _ routeDefinition: Endpoints.RouteDefinition,
        use closure: @escaping (Request) async throws -> Response
    ) -> Route where Response: AsyncResponseEncodable {
        self.on(routeDefinition.httpMethod, routeDefinition.pathComponents, use: closure)
    }
}


// MARK: - Custom Endpoints

extension Endpoints {
    public struct Members {
        public static let root = ["members"]
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":memberID"])
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getSingle.path)
        public static let getTrades = RouteDefinition(root: root, method: .GET, path: ["trades", ":memberID"])
        public static let getAll = RouteDefinition(root: root, method: .GET, path: [])
        public static let update = RouteDefinition(root: root, method: .PUT, path: [":memberID"])
//        public static let search = RouteDefinition(root: root, method: .GET, path: ["search", ":key"])
        public static let search = RouteDefinition(root: root, method: .GET, path: ["search"])
        
//        public static let addCategory = RouteDefinition(root: root, method: .POST, path: getSingle.path + ["categories", ":categoryID"])
    }
    
    public struct Candidates {
        public static let root = ["candidates"]
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":candidateID"])
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getSingle.path)
        public static let getTrades = RouteDefinition(root: root, method: .GET, path: ["trades", ":candidateID"])
        public static let getAll = RouteDefinition(root: root, method: .GET, path: [])
        
//        public static let addCategory = RouteDefinition(root: root, method: .POST, path: getSingle.path + ["categories", ":categoryID"])
    }
    
    public struct Trades {
        public static let root = ["trades"]
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":tradeID"])
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getSingle.path)
        public static let getList = RouteDefinition(root: root, method: .POST, path: ["list"])
    }
    
    public struct Products {
        public static let root = ["products"]
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        public static let getProduct = RouteDefinition(root: root, method: .GET, path: [":productID"])
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getProduct.path)
    }
    
//    public struct Users {
//        public static let root = ["users"]
//        public static let getAll = RouteDefinition(root: root, method: .GET, path: [])
//        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":userID"])
//        public static let create = RouteDefinition(root: root, method: .POST, path: [])
//    }
}
