// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LovelyPetApp",
    // Support macOS 12+; compatibility coverage tracks macOS 26, 15, 14, 13, and 12.
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
