//
//  UserAPIModel+User.swift
//  
//
//  Created by Andrew on 2023/2/8.
//

import Vapor
import JOJACore
import Fluent

extension UserAPIModel: Content {
    func asPublic() throws -> UserAPIModel.Public {
        UserAPIModel.Public(id: id,
                            username: username,
                            createdAt: createdAt,
                            updatedAt: updatedAt)
    }
}

extension UserAPIModel {
    init(user: User) throws {
        try self.init(
            id: user.requireID(),
            username: user.username,
            password: user.passwordHash,
            createdAt: user.createdAt ?? Date(),
            updatedAt: user.updatedAt ?? Date()
        )
    }
    
    func createToken(source: TokenAPIModel.SessionSource) throws -> Token {
        let expiryDate = Date().after(component: .month, value: 1)
        return Token(userId: self.id,
                     token: [UInt8].random(count: 16).base64, source: source,
                     expiresAt: expiryDate, createdAt: Date())
    }
}

extension UserAPIModel.Create {
    func createUser() throws -> User {
        User(username: username, passwordHash: try Bcrypt.hash(password))
    }
}

extension UserAPIModel.Public: Content {}
