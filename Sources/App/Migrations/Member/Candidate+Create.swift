
import Fluent
import JOJACore

extension Candidate {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let whereType = try await database.enum(TypeAPIModel.WhereToKnow.getKey()).read()
            
            try await database
                .schema(Candidate.schema)
                .id()
                .field(Candidate.Keys.name, .string, .required)
                .field(Candidate.Keys.phone, .string, .required)
                .field(Candidate.Keys.birthday, .datetime, .required)
                .field(Candidate.Keys.memberFrom, whereType, .required)
                .field(Candidate.Keys.address, .string)
                .field(Candidate.Keys.email, .string)
                .field(Candidate.Keys.note, .string)
                .field(Candidate.Keys.createdAt, .datetime)
//                .unique(on: Candidate.Keys.email, Candidate.Keys.phone, name: "candidate_unique_setting")
                .unique(on: Candidate.Keys.phone)
                .unique(on: Candidate.Keys.email)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Candidate.schema)
                .delete()
        }
    }
}
