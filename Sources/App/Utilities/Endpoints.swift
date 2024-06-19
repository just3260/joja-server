
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
        
        /// 建立新會員
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        /// 取得會員資料
        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":memberID"])
        /// 刪除會員
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getSingle.path)
        /// 取得此會員所有消費資料
        public static let memberTrades = RouteDefinition(root: root, method: .GET, path: ["trades", ":memberID"])
        /// 取得所有會員資料（簡易資料型態）
        public static let getAll = RouteDefinition(root: root, method: .GET, path: [])
        /// 更新會員資料
        public static let update = RouteDefinition(root: root, method: .PUT, path: [":memberID"])
        /// 搜尋會員資料
        public static let search = RouteDefinition(root: root, method: .GET, path: ["search"])
        
//        public static let search = RouteDefinition(root: root, method: .GET, path: ["search", ":key"])
//        public static let addCategory = RouteDefinition(root: root, method: .POST, path: getSingle.path + ["categories", ":categoryID"])
    }
    
    public struct Candidates {
        public static let root = ["candidates"]
        
        /// 建立新會員資料（給web使用）
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        /// 取得新會員資料明細
        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":candidateID"])
        /// 刪除新會員資料
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getSingle.path)
        /// 取得所有新會員資料
        public static let getAll = RouteDefinition(root: root, method: .GET, path: [])
        
//        public static let addCategory = RouteDefinition(root: root, method: .POST, path: getSingle.path + ["categories", ":categoryID"])
    }
    
    public struct Trades {
        public static let root = ["trades"]
        
        /// 建立單筆交易
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        /// 取得單筆交易資料
        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":tradeID"])
        /// 刪除交易
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getSingle.path)
        /// 取得單筆交易下的商品列表（暫時用不到）
        public static let getList = RouteDefinition(root: root, method: .POST, path: ["list"])
    }
    
    public struct Products {
        public static let root = ["products"]
        
        /// 建立單筆產品
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        /// 取得單筆產品明細
        public static let getProduct = RouteDefinition(root: root, method: .GET, path: [":productID"])
        /// 刪除單筆產品資料
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getProduct.path)
    }
    
    public struct Fabrics {
        public static let root = ["fabrics"]
        
        /// 建立布料
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        /// 取得布料資料
        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":fabricID"])
        /// 刪除布料
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getSingle.path)
        /// 取得布料列表
        public static let getList = RouteDefinition(root: root, method: .POST, path: ["list"])
        /// 加上 tag
        public static let addTag = RouteDefinition(root: root, method: .POST, path: [":fabricID", "addTag"])
        /// 上傳照片
        public static let uploadImage = RouteDefinition(root: root, method: .POST, path: [":fabricID", "image"])
        /// 刪除照片
        public static let deleteImage = RouteDefinition(root: root, method: .DELETE, path: [":fabricID", "image", ":index"])
    }
    
    public struct Tags {
        public static let root = ["tags"]
        
        /// 建立 tag
        public static let create = RouteDefinition(root: root, method: .POST, path: [])
        /// 取得 tag
        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":tagID"])
        /// 刪除 tag
        public static let delete = RouteDefinition(root: root, method: .DELETE, path: getSingle.path)
        /// 取得 tag 列表
        public static let getList = RouteDefinition(root: root, method: .GET, path: ["list"])
    }
    
//    public struct Users {
//        public static let root = ["users"]
//        public static let getAll = RouteDefinition(root: root, method: .GET, path: [])
//        public static let getSingle = RouteDefinition(root: root, method: .GET, path: [":userID"])
//        public static let create = RouteDefinition(root: root, method: .POST, path: [])
//    }
}
