// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "Kawa",
  platforms: [.macOS(.v14)],
  dependencies: [
    .package(url: "https://github.com/sindresorhus/KeyboardShortcuts", from: "1.17.0"),
  ],
  targets: [
    .executableTarget(
      name: "Kawa",
      dependencies: ["KeyboardShortcuts"],
      path: "Sources/Kawa",
      linkerSettings: [.linkedFramework("Carbon")]
    ),
  ]
)
