
import Fluent
import Vapor
import JOJACore

final class User: Model, Content {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Keys.name)
    var username: String
    
    @Field(key: Keys.email)
    var email: String
    
    @Field(key: Keys.password)
    var passwordHash: String
    
    @Field(key: Keys.isAdmin)
    var isAdmin: Bool
    
    @Field(key: Keys.permissions)
    var permissions: Int
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Keys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, username: String, email: String, passwordHash: String, isAdmin: Bool = false, permissions: Int = 37) {
        self.id = id
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
        self.isAdmin = isAdmin
        self.permissions = permissions
    }
}

extension User {
    enum Keys {
        static let schema = "users"
        
        static let name: FieldKey = .username
        static let email: FieldKey = .email
        static let password: FieldKey = .passwordHash
        static let isAdmin: FieldKey = .isAdmin
        static let permissions: FieldKey = .permissions
        static let createdAt: FieldKey = .createdAt
        static let updatedAt: FieldKey = .updatedAt
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        do {
            return try Bcrypt.verify(password, created: self.passwordHash)
        } catch {
            throw Abort(.notAcceptable)
        }
    }
}
