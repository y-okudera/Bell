// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphQL",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "GraphQL",
            targets: [
                "Usecase",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            from: "1.7.1"
        )
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
            ]
        ),
        .target(
            name: "GraphQL",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .target(
            name: "Infra",
            dependencies: [
                "Domain",
                "GraphQL",
                "Usecase",
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .target(
            name: "Interface",
            dependencies: [
                "Domain",
                "Usecase",
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .target(
            name: "Usecase",
            dependencies: [
                "Domain",
                "GraphQL",
            ]
        ),
        .testTarget(
            name: "UsecaseTests",
            dependencies: [
                "Usecase",
            ]
        ),
    ]
)
