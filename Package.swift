// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWWeatherHelper",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWWeatherHelper", targets: ["WWWeatherHelper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWNetworking.git", from: "1.5.1"),
    ],
    targets: [
        .target(name: "WWWeatherHelper", dependencies: ["WWNetworking"], resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
