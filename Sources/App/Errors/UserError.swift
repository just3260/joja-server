//
//  UserError.swift
//  
//
//  Created by Andrew on 2023/2/3.
//

import Vapor

enum UserError: AppError {
    case usernameTaken
}

extension UserError {
    var status: HTTPResponseStatus {
        switch self {
        case .usernameTaken: return .conflict
        }
    }
    
    var reason: String {
        switch self {
        case .usernameTaken: return "Username already taken"
        }
    }
    
    var identifier: String {
        switch self {
        case .usernameTaken:
            return "username_taken"
        }
    }
    
    var description: String {
        reason
    }
    
}
