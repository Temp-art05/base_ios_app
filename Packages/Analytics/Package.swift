// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Analytics",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Analytics", targets: ["Analytics"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.0.0"),
    ],
    targets: [
        .target(
            name: "Analytics",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
            ],
            path: "Sources/Analytics"
        ),
        .testTarget(name: "AnalyticsTests", dependencies: ["Analytics"], path: "Tests/AnalyticsTests"),
    ]
)
