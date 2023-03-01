
import Vapor
import JOJACore
import Fluent

extension MemberAPIModel: Content {
    func asPublic() throws -> MemberAPIModel.Response {
        MemberAPIModel.Response(id: id,
                                name: name,
                                phone: phone,
                                birthday: birthday,
                                from: from,
                                address: address,
                                email: email,
                                note: note,
                                amount: amount,
                                isVip: isVip,
                                createdAt: createdAt,
                                updatedAt: updatedAt,
                                trades: trades
        )
    }
}

extension MemberAPIModel {
    init(member: Member) throws {
//        let tradesss = try member.trades.map({ try TradeAPIModel(trade: $0) })
        try self.init(
            id: member.requireID(),
            name: member.name,
            phone: member.phone,
            birthday: member.birthday,
            from: member.from,
            address: member.address,
            email: member.email,
            note: member.note,
            amount: member.amount,
            isVip: member.isVip,
            createdAt: member.createdAt,
            updatedAt: member.updatedAt,
            trades: try member.trades.map({ try TradeAPIModel(trade: $0) })
        )
    }
}

extension MemberAPIModel.Request {
    func createMember() throws -> Member {
        Member(
            name: name,
            phone: phone,
            birthday: birthday,
            from: from,
            address: address,
            email: email,
            note: note,
            amount: 0,
            isVip: false,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}

extension MemberAPIModel.Response: Content {}
