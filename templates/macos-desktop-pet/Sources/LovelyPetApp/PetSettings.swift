import Foundation

final class PetSettings: ObservableObject {
    @Published var scale: Double
    @Published var isAlwaysOnTop: Bool = true
    @Published var isClickThroughOutsidePet: Bool = false

    let manifest: PetManifest

    init(manifest: PetManifest) {
        self.manifest = manifest
        self.scale = manifest.scale
    }
}
