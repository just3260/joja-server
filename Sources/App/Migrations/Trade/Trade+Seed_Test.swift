
import FluentKit
import Vapor

extension Trade {
    struct Seed_Test: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            let tradeDatas: [[String: Any]] = [
                
                
                
            ]
            
            for data in tradeDatas {
                if let phone = data["phone"] as? String {
                    if let member = try await Member.query(on: database)
                        .filter(\.$phone == phone).first() {
                        if let trade = data["data"] as? Trade, let id = member.id {
                            try await Trade.init(amount: trade.amount, note: trade.note, description: trade.description, buyerID: id, createdAt: trade.createdAt).save(on: database)
                            
                            let total = member.amount + trade.amount
                            try await Member.query(on: database)
                                .set(\.$amount, to: total)
                                .set(\.$isVip, to: total >= Rule.vipThreshold)
                                .filter(\.$id == id)
                                .update()
                        }
                    }
                }
            }
             
        }
        
        func revert(on database: Database) async throws {
            try await Trade.query(on: database).delete()
        }
    }
}
