//
//  TokenAPIModel+Token.swift
//  
//
//  Created by Andrew on 2023/2/8.
//

import Vapor
import JOJACore
import Fluent

extension TokenAPIModel: Content {}

extension TokenAPIModel {
    init(token: Token) throws {
        try self.init(
            id: token.requireID(),
            user: UserAPIModel(user: token.user),
            value: token.value,
            source: TokenAPIModel.SessionSource(rawValue: token.source.rawValue) ?? .login,
            expiresAt: token.expiresAt ?? Date().after(component: .hour, value: 8),
            createdAt: token.createdAt ?? Date()
        )
    }
}

extension TokenAPIModel.Create {
    func makeToken(source: TokenAPIModel.SessionSource) -> Token {
        let expiryDate = Date().after(component: .hour, value: 8)
        return Token(userID: user.id,
                     token: [UInt8].random(count: 16).base64, source: source,
                     expiresAt: expiryDate, createdAt: Date())
    }
}
