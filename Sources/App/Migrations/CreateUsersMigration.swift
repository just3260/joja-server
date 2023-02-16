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
            .field(User.Create.createdAt, .datetime, .required)
            .field(User.Create.updatedAt, .datetime, .required)
            .create()
        
//            .unique(on: User.Create.name, name: "unique_username")
//            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
//        database.schema(User.schema).deleteUnique(on: User.Create.name).update()
    }
}
