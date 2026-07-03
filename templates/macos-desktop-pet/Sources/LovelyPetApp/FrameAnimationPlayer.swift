import AppKit
import Combine
import Foundation

final class FrameAnimationPlayer: ObservableObject {
    @Published private(set) var currentImage: NSImage?
    @Published private(set) var stateName: String

    private static let decodedImageCache = NSCache<NSString, NSImage>()

    private let manifest: PetManifest
    private var timer: Timer?
    private var frameIndex = 0

    init(manifest: PetManifest) {
        self.manifest = manifest
        self.stateName = manifest.defaultState
        loadFrame()
        play(state: manifest.defaultState)
    }

    deinit {
        timer?.invalidate()
    }

    func play(state: String) {
        guard let stateConfig = manifest.states[state] else { return }
        timer?.invalidate()
        timer = nil
        stateName = state
        frameIndex = 0
        loadFrame()

        guard !stateConfig.frames.isEmpty else { return }
        if stateConfig.loop && stateConfig.frames.count <= 1 { return }

        let fps = max(stateConfig.fps, 1)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / Double(fps), repeats: true) { [weak self] _ in
            self?.advance()
        }
    }

    func handleHover(_ hovering: Bool) {
        if hovering, manifest.states["hover"] != nil {
            play(state: "hover")
        } else {
            play(state: manifest.defaultState)
        }
    }

    func handleTap() {
        if manifest.states["tap"] != nil {
            play(state: "tap")
        }
    }

    func handleSleep(_ sleeping: Bool) {
        if sleeping, manifest.states["sleep"] != nil {
            play(state: "sleep")
        } else if stateName == "sleep" {
            play(state: manifest.defaultState)
        }
    }

    private func advance() {
        guard let state = manifest.states[stateName], !state.frames.isEmpty else { return }
        frameIndex += 1
        if frameIndex >= state.frames.count {
            if state.loop {
                frameIndex = 0
            } else {
                play(state: state.nextState ?? manifest.defaultState)
                return
            }
        }
        loadFrame()
    }

    private func loadFrame() {
        guard let state = manifest.states[stateName], !state.frames.isEmpty else {
            currentImage = nil
            return
        }

        let frame = state.frames[min(frameIndex, state.frames.count - 1)]
        currentImage = loadImage(frame: frame)

        if currentImage == nil {
            NSLog("Failed to load PNG pet frame: \(frame)")
        }
    }

    private func loadImage(frame: String) -> NSImage? {
        let reference = FrameReference(rawValue: frame)
        guard reference.path.lowercased().hasSuffix(".png") else {
            NSLog("Ignoring non-PNG pet frame: \(frame)")
            return nil
        }

        guard let url = PetResourceLocator.imageURL(petID: manifest.id, relativePath: reference.path) else {
            NSLog("Missing PNG pet frame: \(reference.path)")
            return nil
        }

        let cacheKey = "\(url.absoluteString)#\(reference.spriteIndex.map(String.init) ?? "full")" as NSString

        if let cachedImage = Self.decodedImageCache.object(forKey: cacheKey) {
            return cachedImage
        }

        guard let sourceImage = NSImage(contentsOf: url) else { return nil }
        let image: NSImage?
        if let spriteIndex = reference.spriteIndex {
            image = crop(spriteSheet: sourceImage, frameIndex: spriteIndex, frameName: frame)
        } else {
            image = sourceImage
        }

        if let image {
            Self.decodedImageCache.setObject(image, forKey: cacheKey)
        }
        return image
    }

    private func crop(spriteSheet: NSImage, frameIndex: Int, frameName: String) -> NSImage? {
        let frameWidth = max(manifest.window.width, 1)
        let frameHeight = max(manifest.window.height, 1)

        guard let cgImage = spriteSheet.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            NSLog("Failed to decode sprite sheet for frame: \(frameName)")
            return nil
        }

        let cropRect = CGRect(
            x: CGFloat(frameIndex * frameWidth),
            y: 0,
            width: CGFloat(frameWidth),
            height: CGFloat(frameHeight)
        )

        guard cropRect.maxX <= CGFloat(cgImage.width), cropRect.maxY <= CGFloat(cgImage.height) else {
            NSLog("Sprite frame is outside sheet bounds: \(frameName)")
            return nil
        }

        guard let cropped = cgImage.cropping(to: cropRect) else {
            NSLog("Failed to crop sprite frame: \(frameName)")
            return nil
        }

        return NSImage(
            cgImage: cropped,
            size: NSSize(width: CGFloat(frameWidth), height: CGFloat(frameHeight))
        )
    }
}

private struct FrameReference {
    let path: String
    let spriteIndex: Int?

    init(rawValue: String) {
        let parts = rawValue.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false)
        path = String(parts.first ?? "")

        if parts.count == 2, let index = Int(parts[1]), index >= 0 {
            spriteIndex = index
        } else {
            spriteIndex = nil
        }
    }
}
