// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DesignSystem",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [.product(name: "Core", package: "Core")],
            path: "Sources/DesignSystem",
            resources: [.process("Resources")]
        ),
    ]
)
