//
//  FieldKey+Joja.swift
//  
//
//  Created by Andrew on 2022/12/20.
//

import Fluent


extension FieldKey {
    // User
    static let username: FieldKey = "username"
    static let email: FieldKey = "email"
    static let passwordHash: FieldKey = "password_hash"
    static let isAdmin: FieldKey = "is_admin"
    
    // Token
    static let userId: FieldKey = "user_id"
    static let value: FieldKey = "value"
    static let source: FieldKey = "source"
    
    // Time
    static let createdAt: FieldKey = "created_at"
    static let updatedAt: FieldKey = "updated_at"
    static let expiresAt: FieldKey = "expires_at"
    
}

// Member
//extension FieldKey {
//    static let memberName: FieldKey = "member_name"
//    static let memberPhone: FieldKey = "member_phone"
//    static let memberBirthday: FieldKey = "member_birthday"
//    static let memberFrom: FieldKey = "member_from"
//    static let memberAddress: FieldKey = "member_address"
//    static let memberEmail: FieldKey = "member_email"
//    static let memberNote: FieldKey = "member_note"
//    static let memberAmount: FieldKey = "member_amount"
//    static let memberVip: FieldKey = "member_vip"
//    static let memberCreateTime: FieldKey = "member_created_time"
//    static let memberLastUpdate: FieldKey = "member_last_update"
//}

// Todo
//extension FieldKey {
//    static let name: FieldKey = "name"
//    static let imageUrl: FieldKey = "image_url"
//    static let title: FieldKey = "title"
//    static let description: FieldKey = "description"
//    static let listID: FieldKey = "list_id"
//}
