
import FluentKit
import Vapor

extension Storage {
    struct Seed: AsyncMigration {
        func prepare(on database: Database) async throws {

            let storages: [Storage] = [
                
                .init(name: "赤峰店", location: .chifeng, description: nil),
                .init(name: "赤峰倉庫", location: .chifengStorage, description: nil),
                .init(name: "台北家", location: .taipeiHome, description: nil),
                .init(name: "台南店", location: .tainan, description: nil),
                .init(name: "大溪", location: .daxi, description: nil),
                .init(name: "阿姨家", location: .aunt, description: nil)
                
            ]
            
            try await withThrowingTaskGroup(of: Void.self, body: { taskGroup in
                for storage in storages {
                    taskGroup.addTask {
                        try await storage.save(on: database)
                    }
                }
                try await taskGroup.waitForAll()
            })
            
        }
        
        func revert(on database: Database) async throws {
            try await Storage.query(on: database).delete()
        }
    }
}
