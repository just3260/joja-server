//
//  File.swift
//  
//
//  Created by Andrew on 2022/12/23.
//

import Vapor
import Fluent
import CRUDKit

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .title)
    var title: String
    
    @Field(key: .description)
    var description: String?
    
    @Parent(key: .listID)
    var list: TodoList
    
    init() {}
    
    init(id: Todo.IDValue? = nil, title: String, description: String?, list_id: TodoList.IDValue?) {
        self.id = id
        self.title = title
        self.description = description
        
        // Use if let for unwrapping the optional
        if let list = list_id {
            self.$list.id = list
        }
    }
}

extension Todo: CRUDModel {
    
    // MARK: - Custom public instance
    
    struct Public: Content {
        var id: UUID?
        var title: String
        var description: String?
    }
    
    var `public`: Public {
        Public.init(id: id, title: title, description: description)
    }
    
    
    // MARK: - Customize create
    
    struct Create: Content {
        var title: String
        var description: String?
        var list_id: TodoList.IDValue?
    }
    
    convenience init(from data: Create) throws {
        self.init(title: data.title, description: data.description, list_id: data.list_id)
    }
    
    
    // MARK: - Customize replace
    
//    struct Replace: Content {
//        var title: String
//        var description: String?
//        var list: TodoList.IDValue?
//    }
//
//    func replace(with data: Replace) throws -> Self {
//        self.init(title: data.title, description: data.description, list: data.list)
//    }
}
