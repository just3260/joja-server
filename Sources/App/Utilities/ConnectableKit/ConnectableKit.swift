//
//  ConnectableKit.swift
//  ConnectableKit
//
//  Created by Tuğcan ÖNBAŞ on 09.04.2023.
//

import Vapor
import FluentPostgresDriver

public struct ConnectableKit {
    private init() {}

    public static func configureErrorMiddleware(_ app: Vapor.Application, errorClosure: ConnectableErrorMiddleware.ErrorClosure? = nil) {
        app.middleware = .init()

//        if let errorClosure = errorClosure {
            
            let errorClosure: ConnectableErrorMiddleware.ErrorClosure = { error in
                        let status: Vapor.HTTPResponseStatus
                        let reason: String
                        let headers: Vapor.HTTPHeaders
                        let source: ErrorSource

                        switch error {
                        case let jojaAbort as JojaError:
                            reason = jojaAbort.reason
                            status = jojaAbort.status
                            headers = jojaAbort.headers
                            source = jojaAbort.source ?? .capture()
                            
                        case let abort as Vapor.AbortError:
                            reason = abort.reason
                            status = abort.status
                            headers = abort.headers
                            source = .capture()
                            
                        case let debugErr as DebuggableError:
                            reason = debugErr.reason
                            status = .internalServerError
                            headers = [:]
                            source = debugErr.source ?? .capture()
                            
                        case let psqlError as PSQLError:
            //                reason = psqlError.description
                            reason = psqlError.pgPoolDescription
                            status = .internalServerError
                            headers = [:]
                            source = .capture()
                            
                            app.logger.log(level: .critical, Logger.Message.init(stringLiteral: psqlError.pgPoolDebugDescription))
                            
                        default:
                            reason = app.environment.isRelease
                                ? "Something went wrong."
                                : String(describing: error)
                            status = .internalServerError
                            headers = [:]
                            source = .capture()
                        }
                        return (status, reason, headers, source)
                    }
            
            app.middleware.use(ConnectableErrorMiddleware.custom(errorClosure: errorClosure))
//        } else {
//            app.middleware.use(ConnectableErrorMiddleware.default(environment: app.environment))
//        }
    }

    public static func configureCORS(_ app: Vapor.Application, configuration: Vapor.CORSMiddleware.Configuration? = nil) {
        let corsConfiguration = configuration ?? Vapor.CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS, .PATCH],
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin, HTTPHeaders.Name.init(stringLiteral: "apiKey")/*, HTTPHeaders.Name.init(stringLiteral: "x-api-key")*/]
        )

        let corsMiddleware = Vapor.CORSMiddleware(configuration: corsConfiguration)
        app.middleware.use(corsMiddleware)
    }
}
