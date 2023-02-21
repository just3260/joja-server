//
//  SignupAPIModel+Signup.swift
//  
//
//  Created by Andrew on 2023/2/10.
//

import Vapor
import JOJACore

extension SignupAPIModel: Content {}

extension SignupAPIModel: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(6...))
    }
}
