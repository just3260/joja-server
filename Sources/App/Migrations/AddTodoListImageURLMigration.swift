//
//  AddTodoListImageUrlMigration.swift
//  
//
//  Created by Andrew on 2022/12/28.
//

import Fluent

struct AddTodoListImageUrlMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(TodoList.schema)
            .field(.imageUrl, .string)
            .update()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(TodoList.schema)
            .deleteField(.imageUrl)
            .update()
    }
}
