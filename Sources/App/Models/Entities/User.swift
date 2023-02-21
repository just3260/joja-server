//
//  User.swift
//  
//
//  Created by Andrew on 2023/2/3.
//

import Fluent
import Vapor
import JOJACore

final class User: Model, Content {
    
    static let schema = Create.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Create.name)
    var username: String
    
    @Field(key: Create.email)
    var email: String
    
    @Field(key: Create.password)
    var passwordHash: String
    
    @Field(key: Create.isAdmin)
    var isAdmin: Bool
    
    @Timestamp(key: Create.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Create.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, username: String, email: String, passwordHash: String, isAdmin: Bool = false) {
        self.id = id
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
        self.isAdmin = isAdmin
    }
}

extension User {
    enum Create {
        static let schema = "users"
        
        static let name: FieldKey = .username
        static let email: FieldKey = .email
        static let password: FieldKey = .passwordHash
        static let isAdmin: FieldKey = .isAdmin
        static let createdAt: FieldKey = .createdAt
        static let updatedAt: FieldKey = .updatedAt
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        do {
            print(passwordHash)
            print(password)
            return try Bcrypt.verify(password, created: self.passwordHash)
        } catch {
            throw Abort(.notAcceptable)
        }
    }
}
