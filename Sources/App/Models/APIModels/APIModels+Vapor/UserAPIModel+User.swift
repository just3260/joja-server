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
                            email: email.lowercased(),
                            isAdmin: isAdmin,
                            createdAt: createdAt,
                            updatedAt: updatedAt
        )
    }
}

extension UserAPIModel {
    init(user: User) throws {
        try self.init(
            id: user.requireID(),
            username: user.username,
            email: user.email,
            password: user.passwordHash,
            isAdmin: user.isAdmin,
            createdAt: user.createdAt ?? Date(),
            updatedAt: user.updatedAt ?? Date()
        )
    }
    
    func createToken(source: TokenAPIModel.SessionSource) throws -> Token {
        let expiryDate = Date().after(component: .hour, value: 8)
        return Token(userID: self.id,
                     token: [UInt8].random(count: 16).base64, source: source,
                     expiresAt: expiryDate, createdAt: Date())
    }
}

extension UserAPIModel.Create {
    func createUser() throws -> User {
        User(username: username, email: email.lowercased(), passwordHash: try Bcrypt.hash(password))
    }
}

extension UserAPIModel.Public: Content {}
