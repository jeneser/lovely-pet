import Foundation
import Combine

final class PetSettings: ObservableObject {
    let manifest: PetManifest

    @Published var scale: Double {
        didSet { UserDefaults.standard.set(scale, forKey: LocalStorageKeys.scale) }
    }
    @Published var isAlwaysOnTop: Bool = true
    @Published var isClickThroughOutsidePet: Bool = false

    init(manifest: PetManifest) {
        self.manifest = manifest
        let savedScale = UserDefaults.standard.double(forKey: LocalStorageKeys.scale)
        self.scale = savedScale > 0 ? savedScale : manifest.scale
    }

    func resetScale() {
        scale = manifest.scale
    }

    func resetLocalData() {
        [
            LocalStorageKeys.affection,
            LocalStorageKeys.scale,
            LocalStorageKeys.windowX,
            LocalStorageKeys.windowY
        ].forEach { UserDefaults.standard.removeObject(forKey: $0) }
        scale = manifest.scale
        UserDefaults.standard.removeObject(forKey: LocalStorageKeys.scale)
        NotificationCenter.default.post(name: .lovelyPetResetLocalData, object: nil)
    }
}
