import Foundation
import Combine
import CoreGraphics

final class PetSettings: ObservableObject {
    static let minimumScale = 0.6
    static let maximumScale = 1.8
    private static let viewportMargin = CGSize(width: 70, height: 90)

    let manifest: PetManifest

    @Published var scale: Double {
        didSet {
            let clamped = Self.clampedScale(scale)
            if scale != clamped {
                scale = clamped
            }
            UserDefaults.standard.set(scale, forKey: LocalStorageKeys.scale)
        }
    }
    @Published var isAlwaysOnTop: Bool = true
    @Published var isClickThroughOutsidePet: Bool = false

    init(manifest: PetManifest) {
        self.manifest = manifest
        let savedScale = UserDefaults.standard.double(forKey: LocalStorageKeys.scale)
        self.scale = savedScale > 0 ? Self.clampedScale(savedScale) : Self.clampedScale(manifest.scale)
    }

    var defaultScale: Double {
        Self.clampedScale(manifest.scale)
    }

    var baseWindowSize: CGSize {
        CGSize(
            width: CGFloat(max(manifest.window.width, 1)),
            height: CGFloat(max(manifest.window.height, 1))
        )
    }

    var viewportWindowSize: CGSize {
        CGSize(
            width: baseWindowSize.width + Self.viewportMargin.width,
            height: baseWindowSize.height + Self.viewportMargin.height
        )
    }

    var scaledWindowSize: CGSize {
        let safeScale = CGFloat(Self.clampedScale(scale))
        return CGSize(
            width: viewportWindowSize.width * safeScale,
            height: viewportWindowSize.height * safeScale
        )
    }

    func resetScale() {
        scale = defaultScale
    }

    func resetLocalData() {
        [
            LocalStorageKeys.scale,
            LocalStorageKeys.windowX,
            LocalStorageKeys.windowY
        ].forEach { UserDefaults.standard.removeObject(forKey: $0) }
        UserDefaults.standard.removeObject(forKey: "lovelyPet.app.affection")
        scale = defaultScale
        UserDefaults.standard.removeObject(forKey: LocalStorageKeys.scale)
        NotificationCenter.default.post(name: .lovelyPetResetLocalData, object: nil)
    }

    static func clampedScale(_ value: Double) -> Double {
        let finiteValue = value.isFinite ? value : minimumScale
        return min(max(finiteValue, minimumScale), maximumScale)
    }
}
