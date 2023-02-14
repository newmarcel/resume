// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ArcwindKit",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(name: "ArcwindKit", targets: ["ArcwindUI", "ArcwindResume"]),
        .library(name: "ArcwindUI", targets: ["ArcwindUI"]),
        .library(name: "ArcwindResume", targets: ["ArcwindResume"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "ArcwindUI", dependencies: ["ArcwindResume"]),
        .target(name: "ArcwindResume", dependencies: []),
        .testTarget(name: "ArcwindResumeTests", dependencies: ["ArcwindResume"]),
    ]
)
