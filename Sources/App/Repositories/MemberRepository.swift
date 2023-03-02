
import Vapor
import Fluent

protocol MemberRepository: Repository {
    func create(_ member: Member) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [Member]
    func find(id: UUID) async throws -> Member?
    func find(email: String) async throws -> Member?
    func count() async throws -> Int
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
    
    func find(id: UUID) async throws -> Member? {
//        try await Member.find(id, on: database)
        
        try await Member.query(on: database)
            .with(\.$trades)
            .filter(\.$id == id)
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
