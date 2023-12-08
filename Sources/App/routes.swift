import Vapor
import Fluent
import Leaf
import JOJACore
import Foundation

func routes(_ app: Application) throws {
    
    let v1Routes = app.grouped("v1")
    
    // MARK: - System
    try v1Routes.register(collection: SystemController())
    try v1Routes.register(collection: ServerInfoController())
    
    
    // MARK: - User
    try v1Routes.register(collection: UserController())
    
    
    // MARK: - Member
    try v1Routes.register(collection: MemberController())
    
    
    // MARK: - Candidate
    try v1Routes.register(collection: CandidateController())
    
    
    // MARK: - Trade
    try v1Routes.register(collection: TradeController())
    
    
    // MARK: - Product
    try v1Routes.register(collection: ProductController())
    
    
    // MARK: - Todo Lists
//    v1Routes.crud("todo-lists", model: TodoList.self) { routes, parentController in
//        routes.crud("todos", children: Todo.self, on: parentController, via: \.$todos)
//
//        routes.get("hello") { _ in "Hello World" }
//    }
    
    
    // MARK: - Website
    try app.register(collection: WebsiteController())
    
    
    app.get { req async in
        "It works!"
//        "Test OK!"
    }

    

}
