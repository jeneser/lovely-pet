import Foundation

struct PetManifest: Codable {
    struct State: Codable {
        let fps: Int
        let loop: Bool
        let frames: [String]
        let nextState: String?
    }

    let id: String
    let name: String
    let scale: Double
    let anchor: String
    let defaultState: String
    let states: [String: State]

    static func loadDefault() -> PetManifest {
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: "pet", withExtension: "json", subdirectory: "Resources/pets/default") else {
            return PetManifest.placeholder
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(PetManifest.self, from: data)
        } catch {
            NSLog("Failed to load pet manifest: \(error)")
            return PetManifest.placeholder
        }
    }

    static let placeholder = PetManifest(
        id: "placeholder",
        name: "Lovely Pet",
        scale: 1.0,
        anchor: "bottom-right",
        defaultState: "idle",
        states: [
            "idle": State(fps: 12, loop: true, frames: [], nextState: nil)
        ]
    )
}
