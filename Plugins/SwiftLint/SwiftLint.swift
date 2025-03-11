//
//  SwiftLint.swift
//
//
//  Created by Vladimir Burdukov on 24/04/2024.
//

import Foundation
import PackagePlugin

@main
struct SwiftLint: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: any PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        guard let files = target.sourceModule?.sourceFiles(withSuffix: "swift").map(\.url) else {
            return []
        }

        return [
            try makeCommand(
                executable: try context.tool(named: "swiftlint").url,
                root: context.package.directoryURL,
                pluginWorkDirectory: context.pluginWorkDirectoryURL,
                files: files
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
    import XcodeProjectPlugin

    extension SwiftLint: XcodeBuildToolPlugin {
        func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
            let files = target.inputFiles.filter { $0.type == .source && $0.url.pathExtension == "swift" }.map(\.url)

            return [
                try makeCommand(
                    executable: try context.tool(named: "swiftlint").url,
                    root: context.xcodeProject.directoryURL,
                    pluginWorkDirectory: context.pluginWorkDirectoryURL,
                    files: files
                )
            ]
        }
    }
#endif

private func makeCommand(
    executable: URL,
    root: URL,
    pluginWorkDirectory: URL,
    files: [URL]
) throws -> PackagePlugin.Command {
    var arguments: [String] = ["lint"]


    if FileManager.default.fileExists(atPath: root.appending(components: ".swiftlint.yml").path(percentEncoded: false)) {
        arguments.append(contentsOf: ["--config", root.appending(components: ".swiftlint.yml").path(percentEncoded: false)])
    }

    if ProcessInfo.processInfo.environment["CI"] == "TRUE" {
        let ciConfigURL = pluginWorkDirectory.appending(path: ".ci.swiftlint.yml")

        if !FileManager.default.fileExists(atPath: ciConfigURL.path(percentEncoded: false)) {
            try """
disabled_rules:
  - todo
""".write(to: ciConfigURL, atomically: true, encoding: .utf8)
        }

        arguments.append(contentsOf: ["--config", ciConfigURL.path(percentEncoded: false)])
        arguments.append("--no-cache")
        arguments.append("--strict")
    } else {
        arguments.append(contentsOf: [
            "--cache-path",
            pluginWorkDirectory.appending(components: "cache").path(percentEncoded: false)
        ])
    }

    arguments.append(contentsOf: files.map { $0.path(percentEncoded: false) })

    return .prebuildCommand(
        displayName: "SwiftLint",
        executable: executable,
        arguments: arguments,
        outputFilesDirectory: pluginWorkDirectory.appending(components: "output")
    )
}
