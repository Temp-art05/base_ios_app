// swift-tools-version: 5.9
import PackageDescription

// Feature package: chỉ phụ thuộc Core / Domain / DesignSystem / Analytics.
// KHÔNG phụ thuộc Data, Networking, Storage hay feature khác.
let package = Package(
    name: "FeatureMain",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureMain", targets: ["FeatureMain"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain"),
        .package(path: "../DesignSystem"),
        .package(path: "../Analytics"),
    ],
    targets: [
        .target(
            name: "FeatureMain",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Analytics", package: "Analytics"),
            ],
            path: "Sources/FeatureMain"
        ),
        .testTarget(name: "FeatureMainTests", dependencies: ["FeatureMain"], path: "Tests/FeatureMainTests"),
    ]
)
