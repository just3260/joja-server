
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
    
    func makeResponse() throws -> MemberAPIModel.Response {
        let trades = try self.trades.map({try $0.makeSimple()}).sorted(by: {$0.createdAt!.compare($1.createdAt!) == .orderedDescending})
        
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
                                       trades: trades
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
                                email: email?.lowercased(),
                                note: note,
                                amount: amount,
                                isVip: isVip,
                                createdAt: createdAt,
                                updatedAt: updatedAt,
                                trades: try trades?.compactMap({try $0.asSimple()})
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
            address: member.address.nilIfEmpty,
            email: member.email.nilIfEmpty,
            note: member.note.nilIfEmpty,
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
            email: email?.lowercased(),
            note: note,
            amount: 0,
            isVip: isVip,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}

extension MemberAPIModel.Response: Content {}
extension MemberAPIModel.ListData: Content {}
