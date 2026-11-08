// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [.product(name: "Core", package: "Core")],
            path: "Sources/Domain"
        ),
        .testTarget(name: "DomainTests", dependencies: ["Domain"], path: "Tests/DomainTests"),
    ]
)
