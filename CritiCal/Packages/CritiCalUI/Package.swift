// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CritiCalUI",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CritiCalUI",
            targets: ["CritiCalUI"]
        ),
    ],
    dependencies: [
        .package(name: "CritiCalDomain", path: "../CritiCalDomain"),
        .package(name: "CritiCalModels", path: "../CritiCalModels")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CritiCalUI",
            dependencies: ["CritiCalDomain", "CritiCalModels"],
            swiftSettings: [
                .defaultIsolation(MainActor.self),                 // Swift 6.2 default actor isolation
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"), // “Approachable Concurrency”
                .enableUpcomingFeature("InferIsolatedConformances")
            ]
        ),
        .testTarget(
            name: "CritiCalUITests",
            dependencies: ["CritiCalUI", "CritiCalDomain"]
        ),
    ]
)
