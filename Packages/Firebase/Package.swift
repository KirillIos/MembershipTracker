// swift-tools-version:5.4

import PackageDescription

let name = "Firebase"

let package = Package(
    name: name,
    defaultLocalization: "ru",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: name,
            targets: [name]),
    ],
    dependencies: [
        .package(name: "FirebaseProxy", path: "../FirebaseProxy")
    ],
    targets: [
        .target(
            name: name,
            dependencies: [
                "FirebaseProxy"
            ]
        )
    ]
)
