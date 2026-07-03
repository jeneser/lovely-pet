import Foundation

struct PetManifest: Codable {
    struct State: Codable {
        let fps: Int
        let loop: Bool
        let frames: [String]
        let nextState: String?
    }

    struct Window: Codable {
        let width: Int
        let height: Int
    }

    let id: String
    let name: String
    let scale: Double
    let anchor: String
    let defaultState: String
    let window: Window
    let states: [String: State]

    static func loadDefault() -> PetManifest {
        for url in PetResourceLocator.manifestURLs() {
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(PetManifest.self, from: data)
            } catch {
                NSLog("Failed to load pet manifest at \(url.path): \(error)")
            }
        }

        return PetManifest.placeholder
    }

    static let placeholder = PetManifest(
        id: "placeholder",
        name: "Lovely Pet",
        scale: 0.6,
        anchor: "bottom-right",
        defaultState: "idle",
        window: Window(width: 320, height: 340),
        states: [
            "idle": State(fps: 12, loop: true, frames: [], nextState: nil)
        ]
    )
}

enum PetResourceLocator {
    static func manifestURLs() -> [URL] {
        candidatePetRoots(petID: "default").map { $0.appendingPathComponent("pet.json") }
    }

    static func imageURL(petID: String, relativePath: String) -> URL? {
        for root in candidatePetRoots(petID: petID) {
            let url = root.appendingPathComponent(relativePath)
            if FileManager.default.fileExists(atPath: url.path) { return url }
        }
        return nil
    }

    private static func candidatePetRoots(petID: String) -> [URL] {
        let fileManager = FileManager.default
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let sourceRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources/pets/\(petID)")

        let roots = [
            Bundle.main.resourceURL?.appendingPathComponent("pets/\(petID)"),
            sourceRoot,
            currentDirectory.appendingPathComponent("Sources/LovelyPetApp/Resources/pets/\(petID)"),
            currentDirectory.appendingPathComponent("templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/\(petID)")
        ].compactMap { $0 }

        return roots.filter { fileManager.fileExists(atPath: $0.path) }
    }
}
