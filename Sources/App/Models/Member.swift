//
//  Member.swift
//  
//
//  Created by Andrew on 2023/1/2.
//

import Vapor
import Fluent
import CRUDKit

enum MemberFromType: Int, Codable {
    case passBy // 路過
    case fb // Facebook
    case ig // Instagram
    case market // 市集
    case search // 網路搜尋
    case friend // 親友介紹
    case pinkoi // Pinkoi
    case eslite // 誠品
    case qsquare // 京站
    case jccac // JCCAC - 香港賽馬協會
    case goyound // 古漾
    case treasureHill // 寶藏巖國際藝術村
    case consignmentShop // 寄賣店
}

final class Member: Model, Content {
    static var schema = "member"
    
    init() { }
    
    @ID(custom: .id)
    var id: UUID?
    
    @Field(key: .memberName)
    var name: String
    
    @Field(key: .memberPhone)
    var phone: String
    
//    @Field(key: .memberBirthday)
    @Timestamp(key: .memberBirthday, on: .none)
    var birthday: Date?
    
    @Field(key: .memberFrom)
    var from: MemberFromType
    
    @Field(key: .memberAddress)
    var address: String?
    
    @Field(key: .memberEmail)
    var email: String?
    
    @Field(key: .memberNote)
    var note: String?
    
    @Field(key: .memberAmount)
    var amount: Int
    
    @Field(key: .memberVip)
    var isVip: Bool
    
//    @Timestamp(key: .memberCreateTime)
    @Timestamp(key: .memberCreateTime, on: .create)
    var created: Date?
    
//    @Timestamp(key: .memberLastUpdate)
    @Timestamp(key: .memberLastUpdate, on: .update)
    var lastUpdate: Date?
    
    init(id: UUID? = nil, name: String, phone: String, birthday: Date, from: MemberFromType, address: String?, email: String?, note: String?) {
        self.id = id
        self.name = name
        self.phone = phone
        self.birthday = birthday
        self.from = from
        self.address = address
        self.email = email
        self.note = note
        self.amount = 0
        self.isVip = false
//        self.created = Date()
//        self.lastUpdate = Date()
    }
}

extension Member: CRUDModel {
    
    // MARK: - Custom response data
    
    struct Public: Content {
        var id: UUID?
        var name: String
        var phone: String
        var birthday: Date?
        var from: MemberFromType
        var address: String?
        var email: String?
        var note: String?
        var amount: Int
        var isVip: Bool
        var created: Date?
        var lastUpdate: Date?
    }

    var `public`: Public {
        Public.init(id: id, name: name, phone: phone, birthday: birthday, from: from, address: address, email: email, note: note, amount: amount, isVip: isVip, created: created, lastUpdate: lastUpdate)
    }
    
    func `public`(eventLoop: EventLoop, db: Database) -> EventLoopFuture<Public> {
        eventLoop.makeSucceededFuture(self.public) 
    }

    
    // MARK: - Customize create data
    
    struct Create: Content {
        var name: String
        var phone: String
        var birthday: Date
        var from: MemberFromType
        var address: String?
        var email: String?
        var note: String?
    }

    convenience init(from data: Create) throws {
//        self.init()
        self.init(name: data.name, phone: data.phone, birthday: data.birthday, from: data.from, address: data.address, email: data.email, note: data.note)
    }

    
    // MARK: - Customize replace data
    
    struct Replace: Content {
        var name: String?
        var phone: String?
        var birthday: Date?
        var from: MemberFromType?
        var address: String?
        var email: String?
        var note: String?
        var amount: Int?
        var isVip: Bool?
    }
    
    func replace(with data: Replace) throws -> Self {
        self.name = data.name ?? self.name
        self.phone = data.phone ?? self.phone
        self.birthday = data.birthday ?? self.birthday
        self.from = data.from ?? self.from
        self.address = data.address ?? self.address
        self.email = data.email ?? self.email
        self.note = data.note ?? self.note
        self.amount = data.amount ?? self.amount
        self.isVip = data.isVip ?? self.isVip
    
//        self.created = self.created
//        self.lastUpdate = Date()
        return self
    }
}


// MARK: - Customize patch data

extension Member: Patchable {
    struct Patch: Content {
        var name: String?
        var phone: String?
        var birthday: Date?
        var from: MemberFromType?
        var address: String?
        var email: String?
        var note: String?
        var amount: Int?
        var isVip: Bool?
    }
    
    func patch(with data: Patch) throws {
        self.name = data.name ?? self.name
        self.phone = data.phone ?? self.phone
        self.birthday = data.birthday ?? self.birthday
        self.from = data.from ?? self.from
        self.address = data.address ?? self.address
        self.email = data.email ?? self.email
        self.note = data.note ?? self.note
        self.amount = data.amount ?? self.amount
        self.isVip = data.isVip ?? self.isVip
    
//        self.created = self.created
//        self.lastUpdate = Date()
    }
}


// MARK: - Validations
/*
extension Todo.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...))
    }
}

extension Member.Replace: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...))
    }
}



extension Member.Patch: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...))
    }
}
*/


// MARK: - Migration

extension Member {
    struct migration: Migration {
        var name = "MemberMigration"
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database
                .schema(Member.schema)
                .field(.id, .uuid, .identifier(auto: true))
                .field(.memberName, .string, .required)
                .field(.memberPhone, .string, .required)
                .field(.memberBirthday, .datetime, .required)
                .field(.memberFrom, .int, .required)
                .field(.memberAddress, .string)
                .field(.memberEmail, .string)
                .field(.memberNote, .string)
                .field(.memberAmount, .int, .required)
                .field(.memberVip, .bool, .required)
                .field(.memberCreateTime, .datetime, .required)
                .field(.memberLastUpdate, .datetime, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database
                .schema(Member.schema)
                .delete()
        }
    }
}
