//
//  File.swift
//  
//
//  Created by Andrew on 2023/1/14.
//

import Vapor
import Fluent

final class SystemController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("sys", "info") { req in
            return InfoData(version: "1.0.0")
        }
    }
}
