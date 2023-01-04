//
//  File+Joja.swift
//  
//
//  Created by Andrew on 2022/12/28.
//

import Vapor

extension File {
    var isImage: Bool {
        [
            "png",
            "jpeg",
            "jpg",
            "gif"
        ].contains(self.extension?.lowercased())
    }
}
