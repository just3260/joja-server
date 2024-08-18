// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "joja-server",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "4.2.4"),
        
        // connectable-kit
//        .package(url: "https://github.com/tugcanonbas/connectable-kit.git", from: "1.0.0"),
        
//        .package(url: "https://github.com/just3260/crud-kit", from: "1.1.1"),
        
        // joja core
//        .package(path: "file:///Users/andrew/Dev/joja-core"), // run in local
        .package(url: "https://github.com/just3260/joja-core", from: "0.1.17"), // run in docker
        
        // Swift Prometheus
//        .package(url: "https://github.com/swift-server/swift-prometheus.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Leaf", package: "leaf"),
//                .product(name: "ConnectableKit", package: "connectable-kit"),
//                .product(name: "CRUDKit", package: "crud-kit"),
                .product(name: "JOJACore", package: "joja-core"),
//                .product(name: "Prometheus", package: "swift-prometheus"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
