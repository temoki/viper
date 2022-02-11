// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "ChatFeature", targets: ["ChatFeature"]),
        .library(name: "ChatUseCase", targets: ["ChatUseCase"]),
        .library(name: "Data", targets: ["Data"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ishkawa/APIKit", .upToNextMajor(from: "5.3.0")),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", .upToNextMajor(from: "9.1.0")),
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "9.2.0")),
    ],
    targets: [
        .target(name: "App", dependencies: ["ChatFeature", "ChatUseCase", "Data", "Core"]),
        .target(name: "Core", dependencies: []),

        // Feature Module
        .target(name: "ChatFeature", dependencies: ["Core", "ChatUseCase"]),
        .target(name: "ChatUseCase", dependencies: ["Core"]),

        // Data Module
        .target(
            name: "Data",
            dependencies: ["Core", "ChatUseCase", "APIKit"]),

        // Tests
        .testTarget(
            name: "DataTests",
            dependencies: [
                "Data", "Quick", "Nimble",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
            ]),
    ],
    swiftLanguageVersions: [.v5]
)
