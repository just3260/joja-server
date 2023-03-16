
import FluentKit
import Vapor

extension Member {
    struct Seed: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            // 帶入預設帳號，建立 User，不會建立 Token
            let members: [Member] = [
                .init(name: "王小花", phone: "0987654321", birthday: Date.init(timeIntervalSince1970: 1604966400), from: .passBy, address: "蜂蜜花園", email: "bear@joja.com", note: "是一隻彩色的熊熊", createdAt: Date(), updatedAt: Date())
            ]
            
            try await withThrowingTaskGroup(of: Void.self, body: { taskGroup in
                for member in members {
                    taskGroup.addTask {
                        try await member.save(on: database)
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
