// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Data", targets: ["Data"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain"),
        .package(path: "../Networking"),
        .package(path: "../Storage"),
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "Networking", package: "Networking"),
                .product(name: "Storage", package: "Storage"),
            ],
            path: "Sources/Data"
        ),
        .testTarget(name: "DataTests", dependencies: ["Data"], path: "Tests/DataTests"),
    ]
)
