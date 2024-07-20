
import FluentKit

extension User {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(User.schema)
                .id()
                .field(User.Keys.name, .string, .required)
                .field(User.Keys.email, .string, .required)
                .field(User.Keys.password, .string, .required)
                .field(User.Keys.isAdmin, .bool, .required, .custom("DEFAULT FALSE"))
                .field(User.Keys.createdAt, .datetime)
                .field(User.Keys.updatedAt, .datetime)
                .unique(on: User.Keys.name, User.Keys.email, name: "user_unique_setting")
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(User.schema)
                .delete()
        }
    }
    
    struct Middleware: AsyncModelMiddleware {
        func create(model: User, on db: Database, next: AnyAsyncModelResponder) async throws {
            // The model can be altered here before it is created.
            model.username = model.username.lowercased()
            try await next.create(model, on: db)
            // Once the User has been created, the code
            // here will be executed.
            print ("User \(model.username) was created")
        }
        
//        func update(model: User, on db: any Database, next: any AnyAsyncModelResponder) async throws {
//            try await next.update(model, on: db)
//        }
    }
}
