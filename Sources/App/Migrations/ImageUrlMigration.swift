//
//  ImageUrlMigration.swift
//  
//
//  Created by Andrew on 2022/12/28.
//

import Fluent

struct ImageUrlMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(TodoList.schema)
            .field(Todo.FieldKeys.imageUrl, .string)
            .update()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(TodoList.schema)
            .deleteField(Todo.FieldKeys.imageUrl)
            .update()
    }
}
