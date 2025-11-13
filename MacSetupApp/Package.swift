// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MacSetupApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "MacSetupApp",
            targets: ["MacSetupApp"])
    ],
    targets: [
        .executableTarget(
            name: "MacSetupApp",
            path: ".",
            sources: ["MacSetupApp.swift"])
    ]
)
