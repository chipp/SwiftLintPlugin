// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftLintPlugin",
    platforms: [
        .macOS("13.0")
    ],
    products: [
        .plugin(
            name: "SwiftLint",
            targets: ["SwiftLint"]
        ),
        .plugin(
            name: "SwiftLintRun",
            targets: ["SwiftLintRun"]
        )
    ],
    targets: [
        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: [
                .target(name: "SwiftLintBinary")
            ]
        ),
        .plugin(
            name: "SwiftLintRun",
            capability: .command(intent: .custom(verb: "swiftlint", description: "Run swiftlint"), permissions: [
                .writeToPackageDirectory(reason: "Fixing SwiftLint issues")
            ]),
            dependencies: [
                .target(name: "SwiftLintBinary")
            ]
        ),
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.63.2/SwiftLintBinary.artifactbundle.zip",
            checksum: "12befab676fc972ffde2ec295d016d53c3a85f64aabd9c7fee0032d681e307e9"
        )
    ]
)