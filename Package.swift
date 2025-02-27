// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftLintPlugin",
    platforms: [
        .macOS(.v13)
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
                .target(name: "swiftlint")
            ]
        ),
        .plugin(
            name: "SwiftLintRun",
            capability: .command(intent: .custom(verb: "swiftlint", description: "Run swiftlint lint --fix"), permissions: [
                .writeToPackageDirectory(reason: "Fixing SwiftLint issues")
            ]),
            dependencies: [
                .target(name: "swiftlint")
            ]
        ),
        .binaryTarget(
            name: "swiftlint",
            url: "https://github.com/realm/SwiftLint/releases/download/0.58.2/SwiftLintBinary.artifactbundle.zip",
            checksum: "f2de7c148dba39bf0ad55ada8f60b15dde383c643c69f7eb2448bd2ed532f659"
        )
    ]
)
