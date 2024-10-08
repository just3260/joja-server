import NIOSSL
import Vapor
import Fluent
import FluentPostgresDriver
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    
    // fot testing in Proxyman
    app.http.server.configuration.port = 3000
    
    setTimeConfigure()
    
    app.routes.defaultMaxBodySize = "10mb"
    app.logger.logLevel = .debug
    
    
    // MARK: - Middleware
    
    app.middleware = .init()
    ConnectableKit.configureCORS(app)
    
    app.middleware.use(RouteLoggingMiddleware(logLevel: .debug))
    
    ConnectableKit.configureErrorMiddleware(app)
//    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
//    app.middleware.use(JOJAErrorMiddleware())
    
    
    // uncomment to serve files from /Public folder
    // FIXME: - 確認 FileMiddleware 是否需要
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
//    app.middleware.use(FileMiddleware(publicDirectory: app.directory.workingDirectory))
    
    app.middleware.use(Logging())
    app.middleware.use(app.sessions.middleware)
    
    
    // MARK: - Leaf
    app.views.use(.leaf)
//    app.leaf.cache.isEnabled = app.environment.isRelease
    
    
    // MARK: - Database
//    app.databases.use(.sqlite(.file("JOJA.sqlite")), as: .sqlite)
    
    
    /*
    let configuration = SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("POSTGRES_USER") ?? "joja",
        password: Environment.get("POSTGRES_PASSWORD") ?? "joja_design",
        database: Environment.get("POSTGRES_DB") ?? "joja_postgres",
        tls: .disable
    )
    
    app.databases.use(.postgres(
        configuration: configuration,
        maxConnectionsPerEventLoop: 1,
        connectionPoolTimeout: .seconds(10),
        encodingContext: .init(jsonEncoder: encoder.joja),
        sqlLogLevel: .debug
    ), as: .psql)
     */
    
    
#if os(Linux) // for NAS
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber, // for NAS
        username: Environment.get("POSTGRES_USER") ?? "joja",
        password: Environment.get("POSTGRES_PASSWORD") ?? "joja_design",
        database: Environment.get("POSTGRES_DB") ?? "joja_postgres",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
#else // Mac
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        // 遠端連進 NAS
//        hostname: "125.228.95.144",
//        port: 12345,
        // Local
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("POSTGRES_USER") ?? "joja",
        password: Environment.get("POSTGRES_PASSWORD") ?? "joja_design",
        database: Environment.get("POSTGRES_DB") ?? "joja_postgres",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
#endif
    
    app.logger.log(level: .info, "database setup done")
    app.logger.log(level: .info, "starting migration")
    
    try routes(app)
    try migrations(app)
    try services(app)
    
    // TODO: - 上版本前確認 Migrate 版本
    try app.autoMigrate().wait()
//    try app.autoRevert().wait()
    
    app.logger.log(level: .info, "migration complete")
    
    // Adding database middleware
    app.logger.notice("Adding database middleware")
    app.databases.middleware.use(User.Middleware(), on: .psql)
}


// MARK: - file private

public func setTimeConfigure() {
    // create a new JSON encoder that uses unix-timestamp dates
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate, .withFullTime]
    
    // Decoder
    ContentConfiguration.global.use(decoder: JSONDecoder.joja, for: .json)
    
    // Encoder
    ContentConfiguration.global.use(encoder: JSONEncoder.joja, for: .json)
}
