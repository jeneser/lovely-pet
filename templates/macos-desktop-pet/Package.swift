// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LovelyPetApp",
    // Support macOS 12 Monterey, 13 Ventura, 14 Sonoma, 15 Sequoia
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
