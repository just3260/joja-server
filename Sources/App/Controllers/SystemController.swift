//
//  File.swift
//  
//
//  Created by Andrew on 2023/1/14.
//

import Vapor
import Fluent
import JOJACore

final class SystemController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protected = routes.grouped(APIKeyCheck())
        protected.get("sys", "info") { req in
            // TODO: - 上版本前更新版號
            return InfoAPIModel(version: "1.0.2")
        }
    }
}
