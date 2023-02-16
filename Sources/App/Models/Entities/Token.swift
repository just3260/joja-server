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
    static let schema = Create.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: Create.userId)
    var user: User
    
    @Field(key: Create.value)
    var value: String
    
    @Field(key: Create.source)
    var source: TokenAPIModel.SessionSource
    
    @Timestamp(key: Create.expiresAt, on: .none)
    var expiresAt: Date?
    
    @Timestamp(key: Create.createdAt, on: .create)
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

extension Token {
    enum Create {
        static let schema = "tokens"
        
        static let userId: FieldKey = .userId
        static let value: FieldKey = .value
        static let source: FieldKey = .source
        static let expiresAt: FieldKey = .expiresAt
        static let createdAt: FieldKey = .createdAt
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
