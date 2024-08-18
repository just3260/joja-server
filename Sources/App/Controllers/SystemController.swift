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
        let protectRoute = routes.grouped(APIKeyCheck())
        let systemRoute = protectRoute.grouped(Endpoints.System.root.toPathComponents)
        
//        systemRoute.post(["sys", "info"], use: info)
        systemRoute.on(Endpoints.System.info, use: info)
    }
    
    fileprivate func info(req: Request) async throws -> InfoAPIModel.DTO {
        // TODO: - 上版本前更新版號
        return InfoAPIModel(version: "1.0.5").toDTO()
    }
}
