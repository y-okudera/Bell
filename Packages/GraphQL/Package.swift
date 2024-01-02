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
                "GraphQL.Domain",
                "GraphQL.Infra",
                "GraphQL.Interface",
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
            name: "GraphQL",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ]
        ),
        .target(
            name: "GraphQL.Dependency",
            path: "Sources/Dependency"
        ),
        .target(
            name: "GraphQL.Domain",
            path: "Sources/Domain"
        ),
        .target(
            name: "GraphQL.Infra",
            dependencies: [
                "GraphQL",
                "GraphQL.Dependency",
                "GraphQL.Domain",
                "GraphQL.Usecase",
                .product(name: "Apollo", package: "apollo-ios"),
            ],
            path: "Sources/Infra"
        ),
        .target(
            name: "GraphQL.Interface",
            dependencies: [
                "GraphQL.Dependency",
                "GraphQL.Domain",
                "GraphQL.Usecase",
                .product(name: "Apollo", package: "apollo-ios"),
            ],
            path: "Sources/Interface"
        ),
        .target(
            name: "GraphQL.Usecase",
            dependencies: [
                "GraphQL",
                "GraphQL.Dependency",
                "GraphQL.Domain",
            ],
            path: "Sources/Usecase"
        ),
        .testTarget(
            name: "UsecaseTests",
            dependencies: [
                "GraphQL.Usecase",
            ]
        ),
    ]
)
