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
    
    static let schema = "users"
    
    @ID(key: "id")
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, username: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
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
