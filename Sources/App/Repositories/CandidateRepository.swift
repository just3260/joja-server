
import Vapor
import Fluent

protocol CandidateRepository: Repository {
    func create(_ candidate: Candidate) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [Candidate]
    func page(with request: Request) async throws -> Page<Candidate>
    func find(id: UUID) async throws -> Candidate?
    func find(email: String) async throws -> Candidate?
    func count() async throws -> Int
//    func gainAmount(with: Int, in candidateID: UUID) async throws
}

struct DatabaseCandidateRepository: CandidateRepository, DatabaseRepository {
    let database: Database
    
    func create(_ candidate: Candidate) async throws {
        try await candidate.create(on: database)
    }
    
    func delete(id: UUID) async throws {
        try await Candidate.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() async throws -> [Candidate] {
        try await Candidate.query(on: database)
//            .with(\.$trades)
            .all()
    }
    
//    func page(withIndex page: Int, size: Int) async throws -> Page<Candidate> {
//        try await Candidate.query(on: database).page(withIndex: page, size: size)
//    }
    
    func page(with request: Request) async throws -> Page<Candidate> {
        try await Candidate.query(on: database).paginate(for: request)
    }
    
    func find(id: UUID) async throws -> Candidate? {
//        try await candidate.find(id, on: database)
        
        try await Candidate.query(on: database)
//            .with(\.$trades)
            .filter(\.$id == id)
            .first()
    }
    
    func find(email: String) async throws -> Candidate? {
        try await Candidate.query(on: database)
            .filter(\.$email == email)
            .first()
    }
    
    func count() async throws -> Int {
        try await Candidate.query(on: database).count()
    }
    
    /*
    func gainAmount(with amount: Int, in candidateID: UUID) async throws {
        guard let candidate = try await Candidate.query(on: database)
            .filter(\.$id == candidateID)
            .first() else {
            throw JojaError.modelNotFound(type: "Candidate", id: candidateID.uuidString)
        }
        
        let total = candidate.amount + amount
        try await Candidate.query(on: database)
            .set(\.$amount, to: total)
            .set(\.$isVip, to: total >= Rule.vipThreshold)
            .filter(\.$id == candidateID)
            .update()
    }
     */
}

extension Application.Repositories {
    var candidates: CandidateRepository {
        guard let storage = storage.makeCandidateRepository else {
            fatalError("CandidateRepository not configured, use: app.candidateRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (CandidateRepository)) {
        storage.makeCandidateRepository = make
    }
}

