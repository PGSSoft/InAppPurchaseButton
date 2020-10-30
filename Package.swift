// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "InAppPurchaseButton",
    platforms: [
        .macOS("10.15"),
        .iOS("8.4")
    ],
    products: [
        .library(name: "InAppPurchaseButton", targets: ["InAppPurchaseButton"])
    ],
    targets: [
        .target(
            name: "InAppPurchaseButton",
            path: "Sources")
    ]
)
