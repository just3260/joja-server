
import Vapor
import JOJACore
import Fluent

extension Product {
    func makePublic() throws -> ProductAPIModel.Response {
        ProductAPIModel.Response(id: try self.requireID(),
                                 brand: self.brand,
                                 goods: self.goods,
                                 material: self.material,
                                 color: self.color,
                                 design: self.design,
                                 amount: self.amount,
                                 count: self.count,
                                 note: self.note,
                                 tradeID: self.$trade.id,
                                 createdAt: self.createdAt
        )
    }
}

extension ProductAPIModel: Content {
    func asPublic() throws -> ProductAPIModel.Response {
        ProductAPIModel.Response(id: id,
                                 brand: brand,
                                 goods: goods,
                                 material: material,
                                 color: color,
                                 design: self.design,
                                 amount: amount,
                                 count: count,
                                 note: note,
                                 tradeID: tradeID,
                                 createdAt: createdAt
        )
    }
}

extension ProductAPIModel {
    init(product: Product) throws {
        try self.init(
            id: product.requireID(),
            brand: product.brand,
            goods: product.goods,
            material: product.material,
            color: product.color,
            design: product.design,
            amount: product.amount,
            count: product.count,
            note: product.note,
            tradeID: product.$trade.id,
            createdAt: product.createdAt
        )
    }
}

extension ProductAPIModel.Request {
    func createProduct(with tradeID: UUID) throws -> Product {
        Product(brand: brand,
                goods: goods,
                material: material,
                color: color,
                design: design,
                amount: amount,
                count: count,
                note: note,
                tradeID: tradeID,
                createdAt: Date()
        )
    }
}

extension ProductAPIModel.Response: Content {}
