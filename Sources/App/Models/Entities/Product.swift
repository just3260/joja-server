import Fluent
import Vapor
import JOJACore

final class Product: Model, Content {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Enum(key: Keys.brand)
    var brand: TypeAPIModel.Brand
    
    @Enum(key: Keys.goods)
    var goods: TypeAPIModel.Goods
    
    @Enum(key: Keys.material)
    var material: TypeAPIModel.Material
    
    @Enum(key: Keys.color)
    var color: TypeAPIModel.Color
    
    @Field(key: Keys.amount)
    var amount: Int
    
    @Field(key: Keys.count)
    var count: Int
    
    @Field(key: Keys.note)
    var note: String?
    
    @Parent(key: Keys.tradeID)
    var trade: Trade
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, brand: TypeAPIModel.Brand, goods: TypeAPIModel.Goods, material: TypeAPIModel.Material, color: TypeAPIModel.Color, amount: Int, count: Int, note: String?, tradeID: Trade.IDValue, createdAt: Date?) {
        self.id = id
        self.brand = brand
        self.goods = goods
        self.material = material
        self.color = color
        self.amount = amount
        self.count = count
        self.note = note
        self.createdAt = createdAt
        self.$trade.id = tradeID
    }
}

extension Product {
    enum Keys {
        static let schema = "products"
        
        static let brand: FieldKey = .brand
        static let goods: FieldKey = .goods
        static let material: FieldKey = .material
        static let color: FieldKey = .color
        static let amount: FieldKey = .amount
        static let count: FieldKey = .count
        static let note: FieldKey = .note
        static let tradeID: FieldKey = .tradeID
        static let createdAt: FieldKey = .createdAt
    }
}
