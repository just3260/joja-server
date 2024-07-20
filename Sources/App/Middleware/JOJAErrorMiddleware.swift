
import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

class JOJAErrorMiddleware: AsyncMiddleware {
    
    internal struct ErrorResponse: Codable {
        /// Always `true` to indicate this is a non-typical JSON response.
        /// The reason for the error.
        var code: Int
        var message: String
        var data: Data?
    }
    
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        do {
            return try await next.respond(to: request)
        } catch let error {
            var reason: String
            var status: HTTPResponseStatus
            var headers: HTTPHeaders
            var source: ErrorSource
            
            switch error {
                
            case let jojaAbort as JojaError:
                reason = jojaAbort.reason
                status = jojaAbort.status
                headers = jojaAbort.headers
                source = jojaAbort.source ?? .capture()
                
            case let abort as AbortError:
                // this is an abort error, we should use its status, reason, and headers
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
                
                request.logger.log(level: .critical, Logger.Message.init(stringLiteral: psqlError.pgPoolDebugDescription))
                
            default:
                // not an abort error, and not debuggable or in dev mode
                // just deliver a generic 500 to avoid exposing any sensitive error info
                print(error.localizedDescription)

                request.logger.log(level: .critical, "Something Went Wrong")
                request.logger.log(level: .critical, Logger.Message.init(stringLiteral: error.localizedDescription))
                reason = "Something went wrong."
                status = .internalServerError
                headers = [:]
                source = .capture()
            }
            
            // Report the error
            request.logger.log(level: .critical, Logger.Message.init(stringLiteral: reason))
            request.logger.report(error: error, file: source.file, function: source.function, line: source.line)
            
            let response = Response(status: .ok, headers: headers)
            
            let errorResponse = ErrorResponse(code: Int(status.code), message: reason, data: nil)
            
            response.body = try .init(data: JSONEncoder.joja.encode(errorResponse))
            response.headers.add(name: .contentType, value: "application/json")
            
            return response
        }
    }
}
