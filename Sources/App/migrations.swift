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
        User.Seed(),
        Member.Seed_Test(),
        Member.Seed_2021(),
        Member.Seed_2022(),
        Member.Seed_2023(),
        Trade.Seed_2021(),
        Trade.Seed_2022(),
        Trade.Seed_2023(),
    ])
    
    
    // unused
//    app.migrations.add(CreateTodoListMigration())
//    app.migrations.add(CreateTodoMigration())
//    app.migrations.add(ImageUrlMigration())
}
