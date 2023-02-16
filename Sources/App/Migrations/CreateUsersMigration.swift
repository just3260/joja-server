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
            .field(User.Create.name, .string, .required)
            .field(User.Create.password, .string, .required)
            .field(User.Create.createdAt, .datetime)
            .field(User.Create.updatedAt, .datetime)
            .unique(on: User.Create.name, name: "unique_username")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
