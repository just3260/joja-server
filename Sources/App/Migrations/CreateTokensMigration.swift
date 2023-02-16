//
//  CreateTokensMigration.swift
//  
//
//  Created by Andrew on 2023/2/3.
//

import Fluent

struct CreateTokensMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema)
            .id()
            .field(Token.Create.userId, .uuid, .references(User.schema, .id))
            .field(Token.Create.value, .string, .required)
            .field(Token.Create.source, .int, .required)
            .field(Token.Create.createdAt, .datetime)
            .field(Token.Create.expiresAt, .datetime)
            .unique(on: Token.Create.value, name: "unique_value")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(Token.schema)
            .delete()
    }
}
