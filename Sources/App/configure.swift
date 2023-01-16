import Vapor
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    
    // fot testing in Proxyman
    app.http.server.configuration.port = 3000
    
    setTimeConfigure()
    
    app.routes.defaultMaxBodySize = "10mb"
    // uncomment to serve files from /Public folder
    //    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.workingDirectory))
    
    app.middleware.use(app.sessions.middleware)
    
    // MARK: - Database
//    app.databases.use(.sqlite(.memory), as: .sqlite)
    app.databases.use(.sqlite(), as: .sqlite)
    
    
    // MARK: - Migrations
    app.migrations.add(Member.migration())
    
    app.migrations.add(CreateTodoListMigration(), to: .sqlite)
    app.migrations.add(CreateTodoMigration(), to: .sqlite)
    app.migrations.add(AddTodoListImageUrlMigration(), to: .sqlite)
    
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
