import Vapor

func migrations(_ app: Application) throws {
    
    // create TypeAPIModel's enum
    app.migrations.add(Types.CreateWhereFromType())
    app.migrations.add(Types.CreateBrandType())
    app.migrations.add(Types.CreateEmployeeType())
    app.migrations.add(Types.CreateGoodsType())
    app.migrations.add(Types.CreateDesignType())
    app.migrations.add(Types.CreateOtherGoodsType())
    app.migrations.add(Types.CreateMaterialType())
    app.migrations.add(Types.CreateTransactionType())
    app.migrations.add(Types.CreateColorType())
    
    // create Model
    app.migrations.add(User.Create())
    app.migrations.add(Token.Create())
    app.migrations.add(Member.Create())
    app.migrations.add(Trade.Create())
    app.migrations.add(Product.Create())
    
    // seed
    app.migrations.add(User.Seed())
    
    
    
    // unused
//    app.migrations.add(CreateTodoListMigration())
//    app.migrations.add(CreateTodoMigration())
//    app.migrations.add(ImageUrlMigration())
}
