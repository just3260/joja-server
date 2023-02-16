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
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.memberName)
    var name: String
    
    @Field(key: FieldKeys.memberPhone)
    var phone: String
    
//    @Field(key: .memberBirthday)
    @Timestamp(key: FieldKeys.memberBirthday, on: .none, format: .iso8601)
    var birthday: Date?
    
    @Field(key: FieldKeys.memberFrom)
    var from: MemberFromType
    
    @Field(key: FieldKeys.memberAddress)
    var address: String?
    
    @Field(key: FieldKeys.memberEmail)
    var email: String?
    
    @Field(key: FieldKeys.memberNote)
    var note: String?
    
    @Field(key: FieldKeys.memberAmount)
    var amount: Int
    
    @Field(key: FieldKeys.memberVip)
    var isVip: Bool
    
//    @Timestamp(key: .memberCreateTime)
    @Timestamp(key: FieldKeys.memberCreateTime, on: .create, format: .iso8601)
    var created: Date?
    
//    @Timestamp(key: .memberLastUpdate)
    @Timestamp(key: FieldKeys.memberLastUpdate, on: .update, format: .iso8601)
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
    
    struct FieldKeys {
        static let memberName: FieldKey = "member_name"
        static let memberPhone: FieldKey = "member_phone"
        static let memberBirthday: FieldKey = "member_birthday"
        static let memberFrom: FieldKey = "member_from"
        static let memberAddress: FieldKey = "member_address"
        static let memberEmail: FieldKey = "member_email"
        static let memberNote: FieldKey = "member_note"
        static let memberAmount: FieldKey = "member_amount"
        static let memberVip: FieldKey = "member_vip"
        static let memberCreateTime: FieldKey = "member_created_time"
        static let memberLastUpdate: FieldKey = "member_last_update"
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
                .id()
                .field(FieldKeys.memberName, .string, .required)
                .field(FieldKeys.memberPhone, .string, .required)
                .field(FieldKeys.memberBirthday, .datetime, .required)
                .field(FieldKeys.memberFrom, .int, .required)
                .field(FieldKeys.memberAddress, .string)
                .field(FieldKeys.memberEmail, .string)
                .unique(on: FieldKeys.memberEmail)
                .field(FieldKeys.memberNote, .string)
                .field(FieldKeys.memberAmount, .int, .required)
                .field(FieldKeys.memberVip, .bool, .required)
                .field(FieldKeys.memberCreateTime, .datetime, .required)
                .field(FieldKeys.memberLastUpdate, .datetime, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database
                .schema(Member.schema)
                .delete()
        }
    }
}
