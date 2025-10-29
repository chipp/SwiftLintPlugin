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
            capability: .command(intent: .sourceCodeFormatting(), permissions: [
                .writeToPackageDirectory(reason: "Fixing SwiftLint issues")
            ]),
            dependencies: [
                .target(name: "SwiftLintBinary")
            ]
        ),
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.62.2/SwiftLintBinary.artifactbundle.zip",
            checksum: "3047357eee0838a0bafc7a6e65cd1aad61734b30d7233e28f3434149fe02f522"
        )
    ]
)