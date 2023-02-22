//
//  CreateUsersMigration.swift
//  
//
//  Created by Andrew on 2023/2/3.
//

import Fluent

struct CreateUsersMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database
            .schema(User.schema)
            .id()
            .field(User.Create.name, .string, .required)
            .field(User.Create.email, .string, .required)
            .field(User.Create.password, .string, .required)
            .field(User.Create.isAdmin, .bool, .required, .custom("DEFAULT FALSE"))
            .field(User.Create.createdAt, .datetime)
            .field(User.Create.updatedAt, .datetime)
            .unique(on: User.Create.name, User.Create.email, name: "unique_setting")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database
            .schema(User.schema)
            .delete()
    }
}
