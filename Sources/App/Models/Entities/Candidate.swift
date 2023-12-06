
import Fluent
import Vapor
import JOJACore

final class Candidate: Model, Content {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Keys.name)
    var name: String
    
    @Field(key: Keys.phone)
    var phone: String
    
    @Timestamp(key: Keys.birthday, on: .none)
    var birthday: Date?
    
    @Enum(key: Keys.memberFrom)
    var from: TypeAPIModel.WhereToKnow
    
    @Field(key: Keys.address)
    var address: String?
    
    @Field(key: Keys.email)
    var email: String?
    
    @Field(key: Keys.note)
    var note: String?
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, name: String, phone: String, birthday: Date?, from: TypeAPIModel.WhereToKnow, address: String?, email: String?, note: String?, createdAt: Date?) {
        self.id = id
        self.name = name
        self.phone = phone
        self.birthday = birthday
        self.from = from
        self.address = address
        self.email = email
        self.note = note
        self.createdAt = createdAt
    }
}

extension Candidate {
    enum Keys {
        static let schema = "candidates"
        
        static let name: FieldKey = .name
        static let phone: FieldKey = .phone
        static let birthday: FieldKey = .birthday
        static let memberFrom: FieldKey = .memberFrom
        static let address: FieldKey = .address
        static let email: FieldKey = .email
        static let note: FieldKey = .note
        static let createdAt: FieldKey = .createdAt
    }
}
