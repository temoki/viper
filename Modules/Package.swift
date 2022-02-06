// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Chat", targets: ["Chat"]),
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Chat", dependencies: ["Core"]),
        .target(name: "Core", dependencies: []),
        .testTarget(name: "ChatTests", dependencies: ["Chat"]),
    ]
)
