//
//  UserController.swift
//  
//
//  Created by Andrew on 2023/2/3.
//

import Vapor
import Fluent
import JOJACore

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protected = routes.grouped(APIKeyCheck())
        let usersRoute = protected.grouped("users")
        usersRoute.post("signup", use: register)
        
        let tokenProtected = usersRoute.grouped(Token.authenticator())
        tokenProtected.get("me", use: getMyOwnUser)
        
        let passwordProtected = usersRoute.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
    }
    
    fileprivate func register(req: Request) async throws -> SessionAPIModel {
        try SignupAPIModel.validate(content: req)
        let userSignup = try req.content.decode(SignupAPIModel.self)
        
        let userModel = UserAPIModel.Create(signup: userSignup)
        let user = try userModel.createUser()
        var token: Token!
        
        guard try await !checkIfUserExists(userSignup.email, req: req) else {
            throw AuthenticationError.emailAlreadyExists
        }
        try await req.users.create(user)
        
        guard let newToken = try? UserAPIModel(user: user).createToken(source: .signup) else {
            throw Abort(.internalServerError)
        }
        token = newToken
        try await req.tokens.save(token)
        return SessionAPIModel(token: token.value, user: try UserAPIModel(user: user).asPublic())
    }
    
    fileprivate func login(req: Request) async throws -> SessionAPIModel {
        let user = try req.auth.require(User.self)
        let token = try UserAPIModel(user: user).createToken(source: .login)
        
        try await req.tokens.save(token)
        return SessionAPIModel(token: token.value, user: try UserAPIModel(user: user).asPublic())
    }
    
    func getMyOwnUser(req: Request) throws -> UserAPIModel.Public {
        let user = try req.auth.require(User.self)
        return try UserAPIModel(user: user).asPublic()
    }
    
    private func checkIfUserExists(_ email: String, req: Request) async throws -> Bool {
        let user = try await req.users.find(email: email.lowercased())
        return user != nil
    }
}
