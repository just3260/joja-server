
import Vapor

extension Request {
    // MARK: Repositories
    var users: UserRepository { application.repositories.users.for(self) }
    var tokens: TokenRepository { application.repositories.tokens.for(self) }
    var members: MemberRepository { application.repositories.members.for(self) }
    var candidates: CandidateRepository { application.repositories.candidates.for(self) }
    var trades: TradeRepository { application.repositories.trades.for(self) }
    var products: ProductRepository { application.repositories.products.for(self) }
    var fabrics: FabricRepository { application.repositories.fabrics.for(self) }
    var tags: TagRepository { application.repositories.tags.for(self) }
}
