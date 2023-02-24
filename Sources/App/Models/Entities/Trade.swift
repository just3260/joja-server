
import Fluent
import Vapor
import JOJACore

final class Trade: Model, Content {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Keys.goods)
    var goods: String
    
    @Field(key: Keys.types)
    var types: [TradeAPIModel.GoodsType]
    
    @Field(key: Keys.amount)
    var amount: Int
    
    @Field(key: Keys.note)
    var note: String?
    
    @Parent(key: Keys.buyerID)
    var buyer: Member
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, goods: String, types: [TradeAPIModel.GoodsType], amount: Int, note: String?, buyerID: Member.IDValue, createdAt: Date?) {
        self.id = id
        self.goods = goods
        self.types = types
        self.amount = amount
        self.note = note
        self.$buyer.id = buyerID
        self.createdAt = createdAt
    }
}

extension Trade {
    enum Keys {
        static let schema = "trades"
        
        static let goods: FieldKey = .goods
        static let types: FieldKey = .types
        static let amount: FieldKey = .amount
        static let note: FieldKey = .note
        static let buyerID: FieldKey = .buyerID
        static let createdAt: FieldKey = .createdAt
    }
}
