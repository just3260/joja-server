
import Vapor
import JOJACore
import Fluent

extension Candidate {
    func makeNewPublic() throws -> CandidateAPIModel.Response {
        return CandidateAPIModel.Response(id: try self.requireID(),
                                          name: self.name,
                                          phone: self.phone,
                                          birthday: self.birthday,
                                          from: self.from,
                                          address: self.address,
                                          email: self.email,
                                          note: self.note,
                                          createdAt: self.createdAt
        )
    }
    
    func makeResponse() throws -> CandidateAPIModel.Response {
        return CandidateAPIModel.Response(id: try self.requireID(),
                                          name: self.name,
                                          phone: self.phone,
                                          birthday: self.birthday,
                                          from: self.from,
                                          address: self.address,
                                          email: self.email,
                                          note: self.note,
                                          createdAt: self.createdAt
        )
    }
    
    func makeList() throws -> CandidateAPIModel.ListData {
        return CandidateAPIModel.ListData(id: try self.requireID(),
                                          name: self.name,
                                          phone: self.phone,
                                          createdAt: self.createdAt
        )
    }
}

extension CandidateAPIModel: Content {
    func asPublic() throws -> CandidateAPIModel.Response {
        CandidateAPIModel.Response(id: id,
                                   name: name,
                                   phone: phone,
                                   birthday: birthday,
                                   from: from,
                                   address: address,
                                   email: email?.lowercased(),
                                   note: note,
                                   createdAt: createdAt
        )
    }
}

extension CandidateAPIModel {
    init(candidate: Candidate) throws {
        try self.init(
            id: candidate.requireID(),
            name: candidate.name,
            phone: candidate.phone,
            birthday: candidate.birthday,
            from: candidate.from,
            address: candidate.address.nilIfEmpty,
            email: candidate.email.nilIfEmpty,
            note: candidate.note.nilIfEmpty,
            createdAt: candidate.createdAt
        )
    }
}

extension CandidateAPIModel.Request {
    func createCandidate() throws -> Candidate {
        Candidate(
            name: name,
            phone: phone,
            birthday: DateConverter.shared.dashDateFormat(birthday ?? ""),
            from: from,
            address: address,
            email: email?.lowercased(),
            note: note,
            createdAt: Date()
        )
    }
}

extension CandidateAPIModel.Response: Content {}
extension CandidateAPIModel.ListData: Content {}
