import Vapor

func migrations(_ app: Application) throws {
    
    // create TypeAPIModel's enum
    app.migrations.add([
        Types.CreateWhereFromType(),
        Types.CreateBrandType(),
        Types.CreateEmployeeType(),
        Types.CreateGoodsType(),
        Types.CreateDesignType(),
        Types.CreateOtherGoodsType(),
        Types.CreateMaterialType(),
        Types.CreateTransactionType(),
        Types.CreateColorType()
    ])
    
    // create Model
    app.migrations.add([
        User.Create(),
        Token.Create(),
        Member.Create(),
        Candidate.Create(),
        Trade.Create(),
        Product.Create()
    ])
    
    // seed
    app.migrations.add([
//        User.Seed(),
//        Member.Seed(),
//        Trade.Seed(),
    ])
    
    
    // unused
//    app.migrations.add(CreateTodoListMigration())
//    app.migrations.add(CreateTodoMigration())
//    app.migrations.add(ImageUrlMigration())
}
