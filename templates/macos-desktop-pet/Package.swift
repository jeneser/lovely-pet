// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LovelyPetApp",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "LovelyPetApp", targets: ["LovelyPetApp"])
    ],
    targets: [
        .executableTarget(
            name: "LovelyPetApp",
            resources: [.copy("Resources")]
        )
    ]
)
