//
//  FieldKey+Joja.swift
//  
//
//  Created by Andrew on 2022/12/20.
//

import Fluent


extension FieldKey {
    // MARK: - User
    static let username: FieldKey = "username"
    static let email: FieldKey = "email"
    static let passwordHash: FieldKey = "password_hash"
    static let isAdmin: FieldKey = "is_admin"
    
    // MARK: - Token
    static let userID: FieldKey = "user_id"
    static let value: FieldKey = "value"
    static let source: FieldKey = "source"
    
    // MARK: - Time
    static let createdAt: FieldKey = "created_at"
    static let updatedAt: FieldKey = "updated_at"
    static let expiresAt: FieldKey = "expires_at"
    
    // MARK: - Member
    static let name: FieldKey = "name"
    static let phone: FieldKey = "phone"
    static let birthday: FieldKey = "birthday"
    static let memberFrom: FieldKey = "member_from"
    static let address: FieldKey = "address"
    static let note: FieldKey = "note"
    static let amount: FieldKey = "amount"
    static let isVip: FieldKey = "is_vip"
    
    // MARK: - Trade
    static let types: FieldKey = "types"
    static let buyerID: FieldKey = "buyer_id"

    // MARK: - Product
    static let brand: FieldKey = "brand_type"
    static let goods: FieldKey = "goods_type"
    static let material: FieldKey = "material_type"
    static let color: FieldKey = "color_type"
    static let design: FieldKey = "design_type"
    static let count: FieldKey = "count"
    static let tradeID: FieldKey = "trade_id"
    static let description: FieldKey = "description"
    
    
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
