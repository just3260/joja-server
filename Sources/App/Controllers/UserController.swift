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
        
        let tokenProtected = usersRoute.grouped(Token.authenticator(), User.guardMiddleware())
        tokenProtected.get("me", use: getMyOwnUser)
        tokenProtected.post("logout", use: logout)
        
        let passwordProtected = usersRoute.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
        
        let adminProtected = tokenProtected.grouped(AdminCheck())
        adminProtected.delete(":userID", use: deleteUser)
    }
    
    fileprivate func register(req: Request) async throws -> SessionAPIModel.DTO {
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
        return SessionAPIModel(token: token.value, user: try UserAPIModel(user: user).asPublic()).toDTO()
    }
    
    fileprivate func login(req: Request) async throws -> SessionAPIModel.DTO {
        let user = try req.auth.require(User.self)
        let token = try UserAPIModel(user: user).createToken(source: .login)
        
        try await req.tokens.save(token)
        return SessionAPIModel(token: token.value, user: try UserAPIModel(user: user).asPublic()).toDTO()
    }
    
    fileprivate func logout(_ req: Request) async throws -> Responser<Connector>.ResponseDTO {
        guard let user = req.auth.get(User.self), let bearer = req.headers["Authorization"].first else {
            throw Abort(.unauthorized)
        }
        guard let bearer = req.headers["Authorization"].first else {
            throw JojaError.modelNotFound(type: "Token", id: user.username)
        }
        let token = bearer.replacingOccurrences(of: "Bearer ", with: "")
        try await req.tokens.delete(token)
        req.auth.logout(User.self)
        return Responser<Connector>.ResponseDTO(status: .success)
    }
    
    fileprivate func deleteUser(_ req: Request) async throws -> Responser<Connector>.ResponseDTO {
      guard let user: User = try await User.find(req.parameters.get("userID"), on: req.db) else {
        throw Abort(.notFound)
      }
      try await user.delete(on: req.db)
        return Responser<Connector>.ResponseDTO(status: .success)
    }
    
    fileprivate func getMyOwnUser(req: Request) async throws -> UserAPIModel.Public.DTO {
        let user = try req.auth.require(User.self)
        return try UserAPIModel(user: user).asPublic().toDTO()
    }
    
    private func checkIfUserExists(_ email: String, req: Request) async throws -> Bool {
        let user = try await req.users.find(email: email.lowercased())
        return user != nil
    }
}
