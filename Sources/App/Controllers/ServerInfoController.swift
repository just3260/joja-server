/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
