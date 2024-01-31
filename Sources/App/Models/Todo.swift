//
//  File.swift
//  
//
//  Created by Andrew on 2022/12/23.
//

/*
import Vapor
import Fluent
import CRUDKit

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.title)
    var title: String
    
    @Field(key: FieldKeys.description)
    var description: String?
    
    @Parent(key: FieldKeys.listID)
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
    
    struct FieldKeys {
        static let name: FieldKey = "name"
        static let imageUrl: FieldKey = "image_url"
        static let title: FieldKey = "title"
        static let description: FieldKey = "description"
        static let listID: FieldKey = "list_id"
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
*/
