import Vapor

func migrations(_ app: Application) throws {
    // Initial Migrations
    app.migrations.add(User.Create())
    app.migrations.add(Token.Create())
    app.migrations.add(Member.Create())
    app.migrations.add(Trade.Create())
    
    app.migrations.add(User.Seed())
    
    
    
//    app.migrations.add(CreateTodoListMigration())
//    app.migrations.add(CreateTodoMigration())
//    app.migrations.add(AddTodoListImageUrlMigration())
}
