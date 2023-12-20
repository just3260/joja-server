
import FluentKit
import Vapor

extension Member {
    struct Seed: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            // 帶入預設帳號，建立 User，不會建立 Token
            let members: [Member] = [
                .init(name: "王小花", phone: "0987654321", birthday: Date.init(timeIntervalSince1970: 1604966400), from: .passBy, address: "蜂蜜花園", email: "bear@joja.com", note: "是一隻彩色的熊熊", createdAt: Date(), updatedAt: Date()),
                .init(name: "橡皮筋", phone: "0912345678", birthday: Date.init(timeIntervalSince1970: 1699228800), from: .friend, address: "Home", email: "elephant@joja.com", note: "皮皮", createdAt: Date(), updatedAt: Date()),
                
                .init(name: "許雪慧", phone: "0921135155", birthday: nil, from: .passBy, address: "大同區", email: "hsahsu1969@gmail.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "蕭涵芳", phone: "0922820116", birthday: nil, from: .market, address: "", email: "0922820116@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "王思涵", phone: "0939606729", birthday: nil, from: .friend, address: "三重區", email: "0939606729@fake.com", note: "蚤操客友＿暖色系", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "張喻涵", phone: "0930639233", birthday: nil, from: .passBy, address: "台南市東區崇德十八街82號", email: "0930639233@fake.com", note: "朋友都是浮誇日系＿髮型師", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "李翌綺", phone: "0952828391", birthday: nil, from: .passBy, address: "蘆洲區", email: "0952828391@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "Jennifer Chan", phone: "85290555595", birthday: nil, from: .passBy, address: "", email: "85290555595@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "林乃潔", phone: "0939202460", birthday: nil, from: .friend, address: "", email: "0939202460@fake.com", note: "古老顧客的朋友", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "林秀姿", phone: "0922059466", birthday: nil, from: .passBy, address: "新北市汐止區", email: "0922059466@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "陳喬音", phone: "0937130315", birthday: nil, from: .passBy, address: "", email: "0937130315@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "蘇家宜", phone: "0937475015", birthday: nil, from: .eslite, address: "", email: "amber19930508@gmail.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "鍾昀庭", phone: "0921665961", birthday: nil, from: .passBy, address: "", email: "yukon123456780@gmail.com", note: "溫柔Bartender", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "Theresa", phone: "852-93286763", birthday: nil, from: .passBy, address: "", email: "852-93286763@fake.com", note: "研究員", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "李映萱", phone: "0911471868", birthday: nil, from: .market, address: "", email: "dianelee0410@gmail.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "林宜霖", phone: "0911080938", birthday: nil, from: .passBy, address: "", email: "0911080938@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "Lo Ka Shun", phone: "85260386505", birthday: nil, from: .passBy, address: "", email: "lokashun_2414@hotmail.com", note: "音樂人", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "李欣鱗", phone: "0937856933", birthday: nil, from: .eslite, address: "", email: "cec78106@gmail.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "江權霖", phone: "0988325139", birthday: nil, from: .passBy, address: "", email: "h5006081234@gmail.com", note: "前衛穿搭", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "陳家莉", phone: "85362338890", birthday: nil, from: .passBy, address: "", email: "85362338890@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "林瑞娥", phone: "0955318639", birthday: nil, from: .passBy, address: "", email: "0955318639@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "李宛儒", phone: "0911004337", birthday: nil, from: .passBy, address: "士林區", email: "lu03925@gmail.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "劉純文", phone: "0920559508", birthday: nil, from: .passBy, address: "", email: "0920559508@fake.com", note: "九折", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "趙昱琳", phone: "（+1）510-8087", birthday: nil, from: .passBy, address: "汐止區大同路三段261-2號25樓", email: "（+1）510-8087@fake.com", note: "九折會員", createdAt: Date.init(timeIntervalSince1970: 1616920800), updatedAt: Date()),
                .init(name: "黃潔", phone: "0911144731", birthday: nil, from: .passBy, address: "台北市北投區復興一路33巷一號4樓", email: "taurus61133@gmail.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1634209140), updatedAt: Date()),
                .init(name: "黃潔恩", phone: "0935870936", birthday: Date.init(timeIntervalSince1970: 905356800), from: .passBy, address: "", email: "0935870936@fake.com", note: "JOJA 店長", createdAt: Date.init(timeIntervalSince1970: 1635415440), updatedAt: Date()),
                .init(name: "洪雅筠", phone: "0987218203", birthday: nil, from: .passBy, address: "新北市三重區大仁街36巷9號", email: "sovywhis@gmail.com", note: "本人85折，親友9折Shopping Design編輯", createdAt: Date.init(timeIntervalSince1970: 1635417960), updatedAt: Date()),
                .init(name: "廖培雯", phone: "0936060121", birthday: Date.init(timeIntervalSince1970: -94032000), from: .passBy, address: "", email: "anandapeiwen@gmail.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1637825100), updatedAt: Date()),
                .init(name: "王棋澐", phone: "0925986060", birthday: Date.init(timeIntervalSince1970: 640713600), from: .fb, address: "新北市新莊區", email: "helen90229@yahoo.com.tw", note: "", createdAt: Date.init(timeIntervalSince1970: 1638959100), updatedAt: Date()),
                .init(name: "蘇祐萩", phone: "0922685216", birthday: Date.init(timeIntervalSince1970: 147711600), from: .passBy, address: "新北市永和區", email: "0922685216@fake.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1640421960), updatedAt: Date()),
                .init(name: "林陸安＊", phone: "0919214151", birthday: Date.init(timeIntervalSince1970: 815155200), from: .ig, address: "台北市中正區", email: "luanjudy@gmail.com", note: "", createdAt: Date.init(timeIntervalSince1970: 1640945100), updatedAt: Date()),
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
