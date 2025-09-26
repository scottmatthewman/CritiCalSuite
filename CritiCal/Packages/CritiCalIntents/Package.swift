// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CritiCalIntents",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CritiCalIntents",
            targets: ["CritiCalIntents"]
        ),
    ],
    dependencies: [
        .package(name: "CritiCalDomain", path: "../CritiCalDomain"),
        .package(name: "CritiCalExtensions", path: "../CritiCalExtensions"),
        .package(name: "CritiCalModels", path: "../CritiCalModels"),
        .package(name: "CritiCalStore", path: "../CritiCalStore"),
        .package(name: "CritiCalUI", path: "../CritiCalUI")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CritiCalIntents",
            dependencies: ["CritiCalDomain", "CritiCalExtensions", "CritiCalModels", "CritiCalStore", "CritiCalUI"],
            swiftSettings: [
                .defaultIsolation(MainActor.self),                 // Swift 6.2 default actor isolation
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"), // “Approachable Concurrency”
                .enableUpcomingFeature("InferIsolatedConformances")
            ]
        ),
        .testTarget(
            name: "CritiCalIntentsTests",
            dependencies: ["CritiCalIntents"]
        ),
    ]
)
