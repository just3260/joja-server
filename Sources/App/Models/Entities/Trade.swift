
import Fluent
import Vapor
import JOJACore

final class Trade: Model, Content {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Keys.amount)
    var amount: Int
    
    @Field(key: Keys.note)
    var note: String?
    
    @Parent(key: Keys.buyerID)
    var buyer: Member
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    @Children(for: \.$trade)
    var products: [Product]
    
    init() {}
    
    init(id: UUID? = nil, amount: Int, note: String?, buyerID: Member.IDValue, createdAt: Date?) {
        self.id = id
        self.amount = amount
        self.note = note
        self.$buyer.id = buyerID
        self.createdAt = createdAt
    }
}

extension Trade {
    enum Keys {
        static let schema = "trades"
        
        static let amount: FieldKey = .amount
        static let note: FieldKey = .note
        static let buyerID: FieldKey = .buyerID
        static let createdAt: FieldKey = .createdAt
    }
}
