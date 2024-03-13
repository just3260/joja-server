
import FluentKit
import Vapor

extension Member {
    struct Seed_Test: AsyncMigration {
        func prepare(on database: Database) async throws {

            let members: [Member] = [
                .init(name: "王小花", phone: "0987654321", birthday: Date.init(timeIntervalSince1970: 1604966400), from: .passBy, address: "蜂蜜花園", email: "bear@joja.com", note: "彩色熊", createdAt: Date(), updatedAt: Date()),
                .init(name: "橡皮筋", phone: "0912345678", birthday: Date.init(timeIntervalSince1970: 1699228800), from: .friend, address: "Home", email: "elephant@joja.com", note: "皮皮", createdAt: Date(), updatedAt: Date()),
                .init(name: "小啾", phone: "0988777666", birthday: Date.init(timeIntervalSince1970: 1659228800), from: .friend, address: "Home", email: "chu@joja.com", note: "小啾", createdAt: Date(), updatedAt: Date()),
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
