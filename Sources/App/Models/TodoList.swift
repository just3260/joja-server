//
//  TodoList.swift
//  
//
//  Created by Andrew on 2022/12/20.
//

import Vapor
import Fluent
import CRUDKit

final class TodoList: Model, Content {
    init() {}
    
    static let schema = "todo-lists"
    
    @ID()
    var id: UUID?
    
    @Field(key: Todo.FieldKeys.name)
    var name: String
    
    @Field(key: Todo.FieldKeys.imageUrl)
    var imageUrl: String?
    
    @Children(for: \.$list)
    var todos: [Todo]
    
    init(id: TodoList.IDValue? = nil, name: String, imageUrl: String?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
}

extension TodoList: CRUDModel {
    
    // MARK: - Custom public instance
    
    struct Public: Content {
        var id: UUID?
        var name: String
        var imageUrl: String?
    }
    
    var `public`: Public {
        Public.init(id: id, name: name, imageUrl: imageUrl)
    }

    func `public`(eventLoop: EventLoop, db: Database) -> EventLoopFuture<Public> {
        eventLoop.makeSucceededFuture(self.public)
    }
    
//    func `public`(eventLoop: EventLoop, db: Database) -> EventLoopFuture<Public> {
//        self.$todos.query(on: db).all().map {
//            Public.init(id: self.id, name: self.name, imageUrl: self.imageUrl)
//        }
//    }
    
    // MARK: - Customize create
    
    struct Create: Content {
        var name: String
    }
    
    convenience init(from data: Create) throws {
        // Call model initializer with default value for imageUrl
        self.init(name: data.name, imageUrl: "")
        
        // Do custom stuff (e.g. hashing passwords)
    }
    
    
    // MARK: - Customize replace
    
    struct Replace: Content {
        var name: String
    }
    
    func replace(with data: Replace) -> Self {
        // Replace all properties manually
        self.name = data.name
        
        // Again you can add custom stuff here
        
        // Return self
        return self
        
        // You can also return a new instance of your model, the id will be preserved.
    }
}


// MARK: - Customize Patch support

extension TodoList: Patchable {
    struct Patch: Content {
        var name: String?
        var imageUrl: String?
    }
    
    func patch(with data: Patch) {
        self.name = data.name ?? self.name
        self.imageUrl = data.imageUrl ?? self.imageUrl
    }
}


// MARK: - Validations

extension TodoList: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(3...))
    }
}

// Using custom structs
extension TodoList.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(3...))
    }
}

extension TodoList.Replace: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(3...))
    }
}

extension TodoList.Patch: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(3...))
    }
}
