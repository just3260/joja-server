//
//  CreateTodoListMigration.swift
//  
//
//  Created by Andrew on 2022/12/20.
//

import Fluent

struct CreateTodoListMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(TodoList.schema)
            .id()
            .field(.name, .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(TodoList.schema)
            .delete()
    }
}


extension Todo {
    struct migration: Migration {
        var name = "TodoMigration"
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("todos")
                .field("id", .int, .identifier(auto: true))
                .field("title", .string, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("todos").delete()
        }
    }
}
