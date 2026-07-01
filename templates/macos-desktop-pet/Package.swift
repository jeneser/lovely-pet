// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LovelyPetApp",
    // Support macOS 12+; coverage tracks macOS 26, macOS 15, macOS 14, macOS 13, and macOS 12.
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "LovelyPetApp", targets: ["LovelyPetApp"])
    ],
    targets: [
        .executableTarget(
            name: "LovelyPetApp",
            resources: [.process("Resources")]
        )
    ]
)
