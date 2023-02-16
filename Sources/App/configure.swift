import Vapor
import Fluent
import FluentSQLiteDriver
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    
    // fot testing in Proxyman
    app.http.server.configuration.port = 3000
    
    setTimeConfigure()
    
    app.routes.defaultMaxBodySize = "10mb"
    
    
    // MARK: - Middleware
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
//    app.middleware.use(FileMiddleware(publicDirectory: app.directory.workingDirectory))
    
    app.middleware.use(Logging())
//    app.middleware.use(APIKeyCheck())
    app.middleware.use(app.sessions.middleware)
    
    
    // MARK: - Database
//    app.databases.use(.sqlite(.file("JOJA.sqlite")), as: .sqlite)
    
    app.databases.use(.postgres(
      hostname: Environment.get("DATABASE_HOST") ?? "localhost",
      port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
      username: Environment.get("POSTGRES_USER") ?? "joja",
      password: Environment.get("POSTGRES_PASSWORD") ?? "joja_design",
      database: Environment.get("POSTGRES_DB") ?? "joja_postgres"
    ), as: .psql)
    
    
    // MARK: - Migrations
    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
    
    app.migrations.add(Member.migration())
    app.migrations.add(CreateUsersMigration())
    app.migrations.add(CreateTokensMigration())
    
    app.migrations.add(CreateTodoListMigration())
    app.migrations.add(CreateTodoMigration())
    app.migrations.add(AddTodoListImageUrlMigration())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}


// MARK: - file private

fileprivate func setTimeConfigure() {
    // create a new JSON encoder that uses unix-timestamp dates
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate, .withFullTime]
    
    // Decoder
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601joja
    ContentConfiguration.global.use(decoder: decoder, for: .json)
    
    // Encoder
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601joja
    ContentConfiguration.global.use(encoder: encoder, for: .json)
}
