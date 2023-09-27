// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWKeychain",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWKeychain", targets: ["WWKeychain"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWPrint.git", from: "1.0.1"),
    ],
    targets: [
        .target(name: "WWKeychain", dependencies: ["WWPrint"]),
        .testTarget(name: "WWKeychainTests", dependencies: ["WWKeychain"]),
    ]
)
