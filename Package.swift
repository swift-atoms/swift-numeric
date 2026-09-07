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
        .library(name: "Numeric Standard Library Integration", targets: ["Numeric Standard Library Integration"]),
        .library(name: "Numeric Foundation Library Integration", targets: ["Numeric Foundation Library Integration"]),
        .library(name: "Numeric Test Support", targets: ["Numeric Test Support"]),
    ],
    dependencies: [
        .package(path: "../../swift-support/swift-numeric-shims"),

        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Numeric",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Numeric Shims", package: "swift-numeric-shims"),
            ],
            path: "Sources/Numeric"
        ),
        .target(
            name: "Numeric Standard Library Integration",
            dependencies: [
                .target(name: "Numeric"),
            ],
            path: "Sources/Numeric Standard Library Integration"
        ),
        .target(
            name: "Numeric Foundation Library Integration",
            dependencies: [
                .target(name: "Numeric"),
                .target(name: "Numeric Standard Library Integration"),
            ],
            path: "Sources/Numeric Foundation Library Integration"
        ),
        .target(
            name: "Numeric Test Support",
            dependencies: [
                .target(name: "Numeric"),
                .product(name: "Tagged Test Support", package: "swift-tagged"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Numeric Tests",
            dependencies: [
                .target(name: "Numeric"),
                .target(name: "Numeric Test Support"),
                .target(name: "Numeric Standard Library Integration"),
                .target(name: "Numeric Foundation Library Integration"),
            ],
            path: "Tests/Numeric Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
