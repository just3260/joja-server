//
//  File.swift
//  
//
//  Created by Andrew on 2024/6/10.
//

import Vapor

extension Request {
    var baseUrl: String {
        let configuration = application.http.server.configuration
        let scheme = configuration.tlsConfiguration == nil ? "http" : "https"
        let host = configuration.hostname
        let port = configuration.port
        return "\(scheme)://\(host):\(port)"
    }
}
