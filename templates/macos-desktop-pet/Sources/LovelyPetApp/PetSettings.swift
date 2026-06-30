import Foundation
import Combine

final class PetSettings: ObservableObject {
    let manifest: PetManifest

    @Published var scale: Double {
        didSet { UserDefaults.standard.set(scale, forKey: scaleKey) }
    }
    @Published var isAlwaysOnTop: Bool = true
    @Published var isClickThroughOutsidePet: Bool = false

    private let scaleKey = "lovelyPet.demo.scale"

    init(manifest: PetManifest) {
        self.manifest = manifest
        let savedScale = UserDefaults.standard.double(forKey: scaleKey)
        self.scale = savedScale > 0 ? savedScale : manifest.scale
    }

    func resetScale() {
        scale = manifest.scale
    }
}
