// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWWeatherHelper",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "WWWeatherHelper", targets: ["WWWeatherHelper"]),
    ],
    dependencies: [
        .package(name: "WWNetworking", url: "https://github.com/William-Weng/WWNetworking.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "WWWeatherHelper", dependencies: ["WWNetworking"]),
        .testTarget(name: "WWWeatherHelperTests",dependencies: ["WWWeatherHelper"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
