//
//  File.swift
//  
//
//  Created by Andrew on 2023/1/14.
//

import Vapor
import Fluent

final class MemberController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protected = routes.grouped(APIKeyCheck())
        protected.crud(Member.schema, model: Member.self) { routes, parentController in
            routes.get("hello") { _ in "Hello World" }
        }
    }
}
