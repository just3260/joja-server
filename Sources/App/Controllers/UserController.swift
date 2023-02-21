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
    
    fileprivate func register(req: Request) throws -> EventLoopFuture<SessionAPIModel> {
        try SignupAPIModel.validate(req)
        let userSignup = try req.content.decode(SignupAPIModel.self)
        
        let userModel = UserAPIModel.Create(signup: userSignup)
        let user = try userModel.createUser()
        
        var token: Token!
        
        return checkIfUserExists(userSignup.email, req: req).flatMap { exists in
            guard !exists else {
                return req.eventLoop.future(error: AuthenticationError.emailAlreadyExists)
            }
            
            return req.users.create(user)
            
//            return user.save(on: req.db)
            
        }.flatMap {
            guard let newToken = try? UserAPIModel(user: user).createToken(source: .signup) else {
                return req.eventLoop.future(error: Abort(.internalServerError))
            }
            token = newToken
            return token.save(on: req.db)
        }.flatMapThrowing {
            SessionAPIModel(token: token.value, user: try UserAPIModel(user: user).asPublic())
        }
    }
    
    fileprivate func login(req: Request) throws -> EventLoopFuture<SessionAPIModel> {
        let user = try req.auth.require(User.self)
        let token = try UserAPIModel(user: user).createToken(source: .login)
        
        return token
            .save(on: req.db)
            .flatMapThrowing {
                SessionAPIModel(token: token.value, user: try UserAPIModel(user: user).asPublic())
            }
    }
    
    func getMyOwnUser(req: Request) throws -> UserAPIModel.Public {
        let user = try req.auth.require(User.self)
        return try UserAPIModel(user: user).asPublic()
    }
    
    private func checkIfUserExists(_ email: String, req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .map { $0 != nil }
    }
}
