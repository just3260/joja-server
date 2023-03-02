
import Vapor

public struct JojaError: Error {
    public enum ErrorIdentifier: String, Codable {
        case missingParameter
        case invalidParameterFormat
        case modelNotFound
        case unableToRetreiveID
        case other
    }
    
    public let errorIdentifier: ErrorIdentifier
    public let reason: String
    
    public static func missingParameter(name: String) -> JojaError {
        JojaError(
            errorIdentifier: .missingParameter,
            reason: "Parameter `\(name)` is missing."
        )
    }
    
    public static func invalidParameterFormat(name: String, desiredType: String) -> JojaError {
        JojaError(
            errorIdentifier: .invalidParameterFormat,
            reason: "Parameter `\(name)` has wrong type (expected: `\(desiredType)`)."
        )
    }
    
    public static func modelNotFound(type: String, id: String) -> JojaError {
        JojaError(
            errorIdentifier: .modelNotFound,
            reason: "Model of type `\(type)` with ID `\(id)` not found"
        )
    }
    
    public static func unableToRetreiveID(type: String) -> JojaError {
        JojaError(
            errorIdentifier: .missingParameter,
            reason: "Model of type `\(type)` has no ID assigned."
        )
    }
    
    public static func other(description: String) -> JojaError {
        JojaError(
            errorIdentifier: .missingParameter,
            reason: "Other error: \(description)"
        )
    }
    
    public init(errorIdentifier: ErrorIdentifier, reason: String) {
        self.errorIdentifier = errorIdentifier
        self.reason = reason
    }
}

extension JojaError: AbortError {
    public var status: HTTPResponseStatus {
        switch self.errorIdentifier {
        case .missingParameter:
            return .badRequest
        case .invalidParameterFormat:
            return .badRequest
        case .modelNotFound:
            return .notFound
        case .unableToRetreiveID:
            return .internalServerError
        case .other:
            return .internalServerError
        }
    }
}


// MARK: - JojaErrorResponse

extension JojaError: DebuggableError {
    public var identifier: String { errorIdentifier.rawValue }
}

public struct JojaErrorResponse: Codable {
    public let error: String
    public let identifier: JojaError.ErrorIdentifier
    public let reason: String
    public let statusCode: UInt
    
    public init(
        identifier: JojaError.ErrorIdentifier,
        reason: String,
        statusCode: UInt
    ) {
        self.error = "true"
        self.identifier = identifier
        self.reason = reason
        self.statusCode = statusCode
    }
}

extension JojaError {
    public init(_ errorResponse: JojaErrorResponse) {
        self.init(errorIdentifier: errorResponse.identifier, reason: errorResponse.reason)
    }
}

extension JojaErrorResponse {
    init(_ error: JojaError) {
        self.init(
            identifier: error.errorIdentifier,
            reason: error.reason,
            statusCode: error.status.code
        )
    }
}