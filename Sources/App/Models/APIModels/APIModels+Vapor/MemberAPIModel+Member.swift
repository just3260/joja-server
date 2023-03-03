
import Vapor
import JOJACore
import Fluent

extension Member {
    func makeNewPublic() throws -> MemberAPIModel.Response {
        return MemberAPIModel.Response(id: try self.requireID(),
                                       name: self.name,
                                       phone: self.phone,
                                       birthday: self.birthday,
                                       from: self.from,
                                       address: self.address,
                                       email: self.email,
                                       note: self.note,
                                       amount: self.amount,
                                       isVip: self.isVip,
                                       createdAt: self.createdAt,
                                       updatedAt: self.updatedAt,
                                       trades: []
        )
    }
    
    func makeList() throws -> MemberAPIModel.ListData {
        return MemberAPIModel.ListData(id: try self.requireID(),
                                       name: self.name,
                                       phone: self.phone,
                                       amount: self.amount,
                                       isVip: self.isVip,
                                       createdAt: self.createdAt
        )
    }
}

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
extension MemberAPIModel.ListData: Content {}
