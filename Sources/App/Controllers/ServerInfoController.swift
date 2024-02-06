
import Vapor

struct ServerInfoResponse: Content {
    let startDate: Date
    let uptime: String?
    let platform: String
}

struct ServerInfoController: RouteCollection {
    let startDate = Date()
    
#if os(Linux)
    private let platform = "Linux"
#else
    private let platform = "macOS"
#endif
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("server-info", use: status)
    }
    
    func status(_ req: Request) -> ServerInfoResponse {
        ServerInfoResponse(startDate: startDate,
                           uptime: uptime(since: startDate),
                           platform: platform)
    }
    
    private func uptime(since date: Date) -> String? {
        let timeInterval = Date().timeIntervalSince(date)
        let duration: String
        
        if timeInterval > 86_400 {
            duration = String(format: "%.2f d", timeInterval/86_400)
        } else if timeInterval > 3_600 {
            duration = String(format: "%.2f h", timeInterval/3_600)
        } else {
            duration = String(format: "%.2f m", timeInterval/60)
        }
        return duration
    }
}
