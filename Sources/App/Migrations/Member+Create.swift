
import Fluent
import JOJACore

extension Member {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let whereType = try await database.enum(TypeAPIModel.WhereToKnow.getKey()).read()
            
            try await database
                .schema(Member.schema)
                .id()
                .field(Member.Keys.name, .string, .required)
                .field(Member.Keys.phone, .string, .required)
                .field(Member.Keys.birthday, .datetime, .required)
                .field(Member.Keys.memberFrom, whereType, .required)
                .field(Member.Keys.address, .string)
                .field(Member.Keys.email, .string)
                .field(Member.Keys.note, .string)
                .field(Member.Keys.amount, .int, .required)
                .field(Member.Keys.isVip, .bool, .required, .custom("DEFAULT FALSE"))
                .field(Member.Keys.createdAt, .datetime)
                .field(Member.Keys.updatedAt, .datetime)
//                .unique(on: Member.Keys.email, Member.Keys.phone, name: "member_unique_setting")
                .unique(on: Member.Keys.phone)
                .unique(on: Member.Keys.email)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Member.schema)
                .delete()
        }
    }
}
