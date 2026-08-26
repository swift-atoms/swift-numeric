// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-numeric",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Numeric", targets: ["Numeric"]),
        .library(name: "Numeric Core", targets: ["Numeric Core"]),
        .library(name: "Real", targets: ["Real"]),
        .library(name: "Numeric Relaxed", targets: ["Numeric Relaxed"]),
        .library(name: "Integer", targets: ["Integer"]),
        .library(
            name: "Numeric Test Support",
            targets: ["Numeric Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-pair.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Numeric Shims",
            publicHeadersPath: "include"
        ),

        .target(
            name: "Numeric Core",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),

        .target(
            name: "Real",
            dependencies: ["Numeric Core", "Numeric Shims"]
        ),

        .target(
            name: "Numeric Relaxed",
            dependencies: ["Numeric Core", "Numeric Shims"]
        ),

        .target(
            name: "Integer",
            dependencies: ["Numeric Core"]
        ),

        .target(
            name: "Numeric",
            dependencies: [
                "Numeric Core",
                "Real",
                "Numeric Relaxed",
                "Integer",
            ]
        ),
        .testTarget(
            name: "Real Tests",
            dependencies: [
                "Real"
            ]
        ),
        .testTarget(
            name: "Numeric Relaxed Tests",
            dependencies: [
                "Numeric Relaxed",
                "Numeric Test Support",
            ]
        ),
        .testTarget(
            name: "Integer Tests",
            dependencies: [
                "Integer"
            ]
        ),

        .target(
            name: "Numeric Test Support",
            dependencies: [
                "Numeric",
                .product(
                    name: "Tagged Test Support",
                    package: "swift-tagged"
                ),
            ],
            path: "Tests/Support"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
