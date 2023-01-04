import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    let v1Routes = app.grouped("v1")
    
    // MARK: - Member
    v1Routes.crud(Member.schema, model: Member.self) { routes, parentController in
        routes.get("hello") { _ in "Hello World" }
    }
    
    // MARK: - Todo Lists
    v1Routes.crud("todo-lists", model: TodoList.self) { routes, parentController in
        routes.crud("todos", children: Todo.self, on: parentController, via: \.$todos)

//        do {
//            try routes.register(collection: TodoListController())
//        } catch {
//            print("error")
//        }

//        routes.get("upload-image", use: { req in
//            "upload image !!"
//        })
        
        routes.get("hello") { _ in "Hello World" }
        
//        let singleListRoutes = routes.grouped(":id")
//        singleListRoutes.post("upload-image", use: uploadImage)
        
//        parentController.setup(routes, on: "upload-image")
        
    }
    
//    let todoListsRoutes = v1Routes.grouped("todo-lists")
//    try todoListsRoutes.register(collection: TodoListController())
    
    app.get { req async in
        "It works!"
    }
}
