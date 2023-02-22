
import Fluent

extension Member {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(Member.schema)
                .id()
                .field(Member.Keys.name, .string, .required)
                .field(Member.Keys.phone, .string, .required)
                .field(Member.Keys.birthday, .datetime, .required)
                .field(Member.Keys.memberFrom, .int, .required)
                .field(Member.Keys.address, .string)
                .field(Member.Keys.email, .string)
                .field(Member.Keys.note, .string)
                .field(Member.Keys.amount, .int, .required)
                .field(Member.Keys.isVip, .bool, .required, .custom("DEFAULT FALSE"))
                .field(Member.Keys.createdAt, .datetime)
                .field(Member.Keys.updatedAt, .datetime)
                .unique(on: Member.Keys.email, Member.Keys.phone, name: "member_unique_setting")
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(Member.schema)
                .delete()
        }
    }
}
