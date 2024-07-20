
import Vapor
import Fluent
import JOJACore

protocol MemberRepository: Repository {
    func create(_ member: Member) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [Member]
    func page(with page: PageRequest) async throws -> Page<Member>
    func find(id: UUID) async throws -> Member?
    func find(phone: String) async throws -> Member?
    func find(email: String) async throws -> Member?
    func count() async throws -> Int
    func gainAmount(with: Int, in memberID: UUID) async throws
    func reduceAmount(with: Int, in memberID: UUID) async throws
    func update(_ member: Member, in memberID: UUID) async throws
    func search(with page: PageRequest, and model: SearchAPIModel<SearchType.Member>) async throws -> Page<Member>
}

struct DatabaseMemberRepository: MemberRepository, DatabaseRepository {
    let database: Database
    
    func create(_ member: Member) async throws {
        try await member.create(on: database)
    }
    
    func delete(id: UUID) async throws {
        try await Member.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() async throws -> [Member] {
        try await Member.query(on: database)
            .with(\.$trades)
            .all()
    }
    
    func page(with page: PageRequest) async throws -> Page<Member> {
        try await Member.query(on: database)
            .sort(\.$createdAt, .descending)
            .page(withIndex: page.page, size: page.per)
    }
    
    func find(id: UUID) async throws -> Member? {
//        try await Member.find(id, on: database)
        
        try await Member.query(on: database)
            .with(\.$trades)
            .filter(\.$id == id)
            .first()
    }
    
    func find(phone: String) async throws -> Member? {
        try await Member.query(on: database)
            .filter(\.$phone == phone)
            .first()
    }
    
    func find(email: String) async throws -> Member? {
        try await Member.query(on: database)
            .filter(\.$email == email)
            .first()
    }
    
    func count() async throws -> Int {
        try await Member.query(on: database).count()
    }
    
    func gainAmount(with amount: Int, in memberID: UUID) async throws {
        guard let member = try await Member.query(on: database)
            .filter(\.$id == memberID)
            .first() else {
            throw JojaError.modelNotFound(type: "Member", id: memberID.uuidString)
        }
        
        let total = member.amount + amount
        try await Member.query(on: database)
            .set(\.$amount, to: total)
            .set(\.$isVip, to: total >= Rule.vipThreshold)
            .filter(\.$id == memberID)
            .update()
    }
    
    func reduceAmount(with amount: Int, in memberID: UUID) async throws {
        guard let member = try await Member.query(on: database)
            .filter(\.$id == memberID)
            .first() else {
            throw JojaError.modelNotFound(type: "Member", id: memberID.uuidString)
        }
        
        let total = member.amount - amount
        try await Member.query(on: database)
            .set(\.$amount, to: total)
            .set(\.$isVip, to: total >= Rule.vipThreshold)
            .filter(\.$id == memberID)
            .update()
    }
    
    func update(_ member: Member, in memberID: UUID) async throws {
        
        try await Member.query(on: database)
            .set(\.$name, to: member.name)
            .set(\.$phone, to: member.phone)
            .set(\.$birthday, to: member.birthday)
            .set(\.$from, to: member.from)
            .set(\.$address, to: member.address)
            .set(\.$email, to: member.email)
            .set(\.$note, to: member.note)
            .set(\.$isVip, to: member.isVip)
            .filter(\.$id == memberID)
            .update()
        
        
        /*
        guard var existMember = try await Member.query(on: database)
            .filter(\.$id == memberID)
            .first() else {
            throw JojaError.modelNotFound(type: "Member", id: memberID.uuidString)
        }
        existMember = member
        try await existMember.save(on: database)
         */
    }
    
    func search(with page: PageRequest, and model: SearchAPIModel<SearchType.Member>) async throws -> Page<Member> {
        let type = model.type.first
        
        switch type {
        case .name:
            return try await Member.query(on: database)
                .filter(model.matchAll ? \.$name == model.key : \.$name ~~ model.key)
                .sort(\.$createdAt, .descending)
                .page(withIndex: page.page, size: page.per)
            
        case .email:
            return try await Member.query(on: database)
                .filter(model.matchAll ? \.$email == model.key : \.$email ~~ model.key)
                .sort(\.$createdAt, .descending)
                .page(withIndex: page.page, size: page.per)
            
        case .note:
            return try await Member.query(on: database)
                .filter(model.matchAll ? \.$note == model.key : \.$note ~~ model.key)
                .sort(\.$createdAt, .descending)
                .page(withIndex: page.page, size: page.per)
            
        case .isVip:
            return try await Member.query(on: database)
                .filter(\.$isVip == true)
                .sort(\.$createdAt, .descending)
                .page(withIndex: page.page, size: page.per)
            
        default: // .phone type
            return try await Member.query(on: database)
                .filter(model.matchAll ? \.$phone == model.key : \.$phone ~~ model.key)
                .sort(\.$createdAt, .descending)
                .page(withIndex: page.page, size: page.per)
        }
    }
}

extension Application.Repositories {
    var members: MemberRepository {
        guard let storage = storage.makeMemberRepository else {
            fatalError("MemberRepository not configured, use: app.memberRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (MemberRepository)) {
        storage.makeMemberRepository = make
    }
}
