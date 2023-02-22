
import FluentKit
import Vapor

extension User {
    struct Seed: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            // 帶入預設帳號，建立 User，不會建立 Token
            let users: [User] = [
                .init(username: "andrewang", email: "just3260@gmail.com", passwordHash: try Bcrypt.hash("a12345678")),
                .init(username: "andrew", email: "andrew@ins.to", passwordHash: try Bcrypt.hash("a12345678"))
            ]
            
            try await withThrowingTaskGroup(of: Void.self, body: { taskGroup in
                for user in users {
                    taskGroup.addTask {
                        try await user.save(on: database)
                    }
                }
                try await taskGroup.waitForAll()
            })
        }
        
        func revert(on database: Database) async throws {
            try await Member.query(on: database).delete()
        }
    }
}
