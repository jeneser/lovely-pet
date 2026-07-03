import Foundation
import Combine
import CoreGraphics

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

    var baseWindowSize: CGSize {
        CGSize(
            width: CGFloat(max(manifest.window.width, 1)),
            height: CGFloat(max(manifest.window.height, 1))
        )
    }

    var scaledWindowSize: CGSize {
        CGSize(
            width: baseWindowSize.width * CGFloat(scale),
            height: baseWindowSize.height * CGFloat(scale)
        )
    }

    func resetScale() {
        scale = manifest.scale
    }

    func resetLocalData() {
        [
            LocalStorageKeys.scale,
            LocalStorageKeys.windowX,
            LocalStorageKeys.windowY
        ].forEach { UserDefaults.standard.removeObject(forKey: $0) }
        UserDefaults.standard.removeObject(forKey: "lovelyPet.app.affection")
        scale = manifest.scale
        UserDefaults.standard.removeObject(forKey: LocalStorageKeys.scale)
        NotificationCenter.default.post(name: .lovelyPetResetLocalData, object: nil)
    }
}
