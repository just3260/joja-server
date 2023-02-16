//
//  File.swift
//  
//
//  Created by Andrew on 2023/2/16.
//

//import Fluent
//import FluentKit

/*
extension Tool {
    struct Create: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database
                .schema(Tool.schema)
                .id()
                .field(Tool.Create_20210531.name, .string, .required)
                .field(Tool.Create_20210531.createdAt, .datetime)
                .field(Tool.Create_20210531.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("tools").delete()
        }
    }
}

extension Tool {
    struct AddMaker: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database
                .schema(Tool.schema)
                .field(Tool.AddMaker_20210601.maker, .string)
                .update()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database
                .schema(Tool.schema)
                .deleteField(Tool.AddMaker_20210601.maker)
                .update()
        }
    }
}

extension Tool {
    struct MakeToolUnique: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database
                .schema(Tool.schema)
                .unique(
                    on: Tool.Create_20210531.name, Tool.AddMaker_20210601.maker,
                    name: "unique_tool_maker"
                )
                .update()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database
                .schema(Tool.schema)
                .deleteUnique(
                    on: Tool.Create_20210531.name,
                    Tool.AddMaker_20210601.maker
                )
                .update()
        }
    }
}

extension Tool {
    struct Seed: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            let tools: [Tool] = [
                .init(name: "Hammer", maker: nil),
                .init(name: "Food Processor", maker: "Bosch"),
                .init(name: "Zigsaw", maker: "Makita")
            ]
            return tools.map { tool in
                tool.save(on: database)
            }
            .flatten(on: database.eventLoop)
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            Tool.query(on: database).delete()
        }
    }
}
*/
