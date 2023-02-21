import Vapor

func migrations(_ app: Application) throws {
    // Initial Migrations
    app.migrations.add(Member.migration())
    app.migrations.add(CreateUsersMigration())
    app.migrations.add(CreateTokensMigration())
    
    app.migrations.add(CreateTodoListMigration())
    app.migrations.add(CreateTodoMigration())
    app.migrations.add(AddTodoListImageUrlMigration())
}
