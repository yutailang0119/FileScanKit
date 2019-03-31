// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileScanKit",
    products: [
        .library(
            name: "FileScanKit",
            targets: ["FileScanKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FileScanKit",
            dependencies: ["PathKit"]),
        .testTarget(
            name: "FileScanKitTests",
            dependencies: ["FileScanKit"]),
    ]
)
