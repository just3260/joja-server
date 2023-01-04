//
//  File.swift
//
//
//  Created by Andrew on 2022/12/21.
//

import Vapor

final class TodoListController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
//        routes.get(use: getAllEntities)
//        routes.post(use: postEntity)

        routes.get("upload-image", use: uploadImage)
        
//        let singleListRoutes = routes.grouped(":id")
//        singleListRoutes.post("upload-image", use: uploadImage)
//        singleListRoutes.get(use: getEntity)
        
//        let todosRoutes = singleListRoutes.grouped("todos")
//        try todosRoutes.register(collection: TodoController())
    }
    
    
    // MARK: GET
    
//    private func getEntity(req: Request) throws -> EventLoopFuture<Response> {
//        let uuid = req.parameters.get("id", as: UUID.self)
//        return TodoList.find(uuid, on: req.db)
//            .unwrap(orError: Abort(.notFound))
//            .flatMap { list in
//                list.$todos.load(on: req.db).map { list }
//            }
//            .encodeResponse(for: req)
//    }
    
//    private func getAllEntities(req: Request) throws -> EventLoopFuture<Response> {
//        let limit = req.query[Int.self, at: "limit"] ?? 100
//        let offset = req.query[Int.self, at: "offset"] ?? 0
//        return TodoList.query(on: req.db)
//            .range(offset..<(limit + offset))
//            .with(\.$todos)
//            .all()
//            .encodeResponse(for: req)
//    }
    
    // MARK: POST
    
//    private func postEntity(req: Request) throws -> EventLoopFuture<Response> {
//        let todoList = try req.content.decode(TodoList.self)
//        return todoList.save(on: req.db)
//            .map { todoList }
//            .encodeResponse(status: .created, for: req)
//    }
    
    
    // MARK: Multipart
    
    private func uploadImage(req: Request) throws -> EventLoopFuture<Response> {
        
//        return TodoList.query(on: req.db)
//            .all()
//            .encodeResponse(status: .ok, for: req)
        
        let uuid = req.parameters.get("id", as: UUID.self)
        let file = try req.content.decode(File.self)
        var fileName = "\(uuid?.uuidString ?? "").\(Date().timeIntervalSince1970)"
        fileName = file.extension.flatMap { "\(fileName).\($0)" } ?? fileName
//        let path = req.application.directory.workingDirectory + fileName
        
        guard file.isImage else {
            throw Abort(.badRequest)
        }
        
        return TodoList
            .find(uuid, on: req.db)
            .unwrap(orError: Abort(.notFound))
            .flatMap { list in
                req.fileio
                    .writeFile(file.data, at: fileName)
                    .map { list }
            }
            .flatMap { list in
                let serverConfig = req.application.http.server.configuration
                let hostname = serverConfig.hostname
                let port = serverConfig.port
                list.imageUrl = "\(hostname):\(port)/\(file.filename)"
                return list.update(on: req.db)
                    .map { list }
                    .encodeResponse(status: .accepted, for: req)
            }
    }
}
