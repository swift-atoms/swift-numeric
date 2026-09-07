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

        .library(name: "Numeric Foundation Integration", targets: ["Numeric Foundation Integration"]),
        .library(name: "Numeric Test Support", targets: ["Numeric Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-quantizer.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-rounding.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-addition.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-subtraction.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-multiplication.git", branch: "main"),
        .package(url: "https://github.com/swift-institute/swift-numeric-shims.git", branch: "main"),

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
                .product(name: "Quantizer", package: "swift-quantizer"),
                .product(name: "Rounding", package: "swift-rounding"),
                .product(name: "Addition", package: "swift-addition"),
                .product(name: "Subtraction", package: "swift-subtraction"),
                .product(name: "Multiplication", package: "swift-multiplication"),

                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Numeric Shims", package: "swift-numeric-shims"),
            ],
            path: "Sources/Numeric"
        ),
        
        .target(
            name: "Numeric Foundation Integration",
            dependencies: [
                .target(name: "Numeric"),
            ],
            path: "Sources/Numeric Foundation Integration"
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
                .target(name: "Numeric Foundation Integration"),
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
