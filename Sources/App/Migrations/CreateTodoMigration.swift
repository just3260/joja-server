//
//  CreateTodoMigration.swift
//  
//
//  Created by Andrew on 2022/12/23.
//

/*
import Fluent

struct CreateTodoMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database
            .schema(Todo.schema)
            .id()
            .field(Todo.FieldKeys.title, .string, .required)
            .field(Todo.FieldKeys.description, .string)
            .field(Todo.FieldKeys.listID, .uuid, .references(TodoList.schema, .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database
            .schema(Todo.schema)
            .delete()
    }
}
*/
