// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CritiCalStore",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CritiCalStore",
            targets: ["CritiCalStore"],
        ),
    ],
    dependencies: [
        .package(name: "CritiCalModels", path: "../CritiCalModels")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CritiCalStore",
            dependencies: ["CritiCalModels"],
            swiftSettings: [
              .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
              .enableUpcomingFeature("InferIsolatedConformances")
            ]
        ),
        .testTarget(
            name: "CritiCalStoreTests",
            dependencies: ["CritiCalStore"]
        ),
    ]
)
