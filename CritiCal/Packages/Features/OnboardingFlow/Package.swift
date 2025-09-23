// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OnboardingFlow",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "OnboardingFlow",
            targets: ["OnboardingFlow"]),
    ],
    targets: [
        .target(
            name: "OnboardingFlow",
            swiftSettings: [
                .defaultIsolation(MainActor.self),                 // Swift 6.2 default actor isolation
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"), // “Approachable Concurrency”
                .enableUpcomingFeature("InferIsolatedConformances")
            ]
        ),
        .testTarget(
            name: "OnboardingFlowTests",
            dependencies: ["OnboardingFlow"]
        ),
    ]
)
