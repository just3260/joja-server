//
//  CreateUsersMigration.swift
//  
//
//  Created by Andrew on 2023/2/3.
//

import Fluent

struct CreateUsersMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .id()
            .field("username", .string, .required)
            .unique(on: "username")
            .field("password_hash", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
