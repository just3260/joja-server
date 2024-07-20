
import FluentKit
import Vapor

extension User {
    struct Seed: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            // 帶入預設帳號，建立 User，不會建立 Token
            let users: [User] = [
                .init(username: "andrewang", email: "just3260@gmail.com", passwordHash: try Bcrypt.hash("a12345678")),
                .init(username: "andrew", email: "andrew@ins.to", passwordHash: try Bcrypt.hash("a12345678")),
                .init(username: "josie", email: "joja.design@hatmail.com", passwordHash: try Bcrypt.hash("Aa0909")),
                .init(username: "jn", email: "jnhuang870910@gmail.com", passwordHash: try Bcrypt.hash("0935870936")),
                .init(username: "mini", email: "kitu8200@gmail.com", passwordHash: try Bcrypt.hash("88888888")),
                .init(username: "jacqueline", email: "jacqueline1225.jl@gmail.com", passwordHash: try Bcrypt.hash("88888888")),
                .init(username: "shin", email: "sh03in08@gmail.com", passwordHash: try Bcrypt.hash("88888888")),
                .init(username: "masako", email: "masako551177@gmail.com", passwordHash: try Bcrypt.hash("88888888")),
                .init(username: "howfun", email: "gung80503@gmail.com", passwordHash: try Bcrypt.hash("88888888")),
                .init(username: "yuu", email: "Gackt0903@hotmail.com", passwordHash: try Bcrypt.hash("88888888")),
                .init(username: "jorie", email: "jk632122@gmail.com", passwordHash: try Bcrypt.hash("88888888")),
                .init(username: "yayun", email: "show871006@gmail.com", passwordHash: try Bcrypt.hash("88888888")),
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
            try await User.query(on: database).delete()
        }
    }
}
