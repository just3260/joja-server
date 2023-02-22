//
//  services.swift
//  
//
//  Created by Andrew on 2023/2/17.
//

import Vapor

func services(_ app: Application) throws {
//    app.randomGenerators.use(.random)
    app.repositories.use(.database)
}
