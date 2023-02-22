
import Fluent
import Vapor
import JOJACore

final class Member: Model, Content {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Keys.name)
    var name: String
    
    @Field(key: Keys.phone)
    var phone: String
    
    @Timestamp(key: Keys.birthday, on: .none)
    var birthday: Date?
    
    @Field(key: Keys.memberFrom)
    var from: MemberAPIModel.FromType
    
    @Field(key: Keys.address)
    var address: String?
    
    @Field(key: Keys.email)
    var email: String?
    
    @Field(key: Keys.note)
    var note: String?
    
    @Field(key: Keys.amount)
    var amount: Int
    
    @Field(key: Keys.isVip)
    var isVip: Bool
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Keys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, name: String, phone: String, birthday: Date?, from: MemberAPIModel.FromType, address: String?, email: String?, note: String?, amount: Int = 0) {
        self.id = id
        self.name = name
        self.phone = phone
        self.birthday = birthday
        self.from = from
        self.address = address
        self.email = email
        self.note = note
        self.amount = amount
    }
}

extension Member {
    enum Keys {
        static let schema = "members"
        
        static let name: FieldKey = .name
        static let phone: FieldKey = .phone
        static let birthday: FieldKey = .birthday
        static let memberFrom: FieldKey = .memberFrom
        static let address: FieldKey = .address
        static let email: FieldKey = .email
        static let note: FieldKey = .note
        static let amount: FieldKey = .amount
        static let isVip: FieldKey = .isVip
        static let createdAt: FieldKey = .createdAt
        static let updatedAt: FieldKey = .updatedAt
    }
}
