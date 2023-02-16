//
//  Token.swift
//  
//
//  Created by Andrew on 2023/2/3.
//

import Vapor
import Fluent
import JOJACore

final class Token: Model, Content {
    static let schema = "tokens"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "value")
    var value: String
    
    @Field(key: "source")
    var source: TokenAPIModel.SessionSource
    
    @Timestamp(key: "expires_at", on: .none, format: .iso8601)
    var expiresAt: Date?
    
    @Timestamp(key: "created_at", on: .create, format: .iso8601)
    var createdAt: Date?
    
    
    init() {}
    
    init(id: UUID? = nil, userId: User.IDValue, token: String, source: TokenAPIModel.SessionSource, expiresAt: Date, createdAt: Date) {
        self.id = id
        self.$user.id = userId
        self.value = token
        self.source = source
        self.expiresAt = expiresAt
        self.createdAt = createdAt
    }
}

extension Token: ModelTokenAuthenticatable {
    static let valueKey = \Token.$value
    static let userKey = \Token.$user
    
    var isValid: Bool {
        guard let expiryDate = expiresAt else {
            return true
        }
        return expiryDate > Date()
    }
}
