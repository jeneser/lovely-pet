import AppKit
import Foundation

final class FrameAnimationPlayer: ObservableObject {
    @Published private(set) var currentImage: NSImage?
    @Published private(set) var stateName: String

    private static let decodedImageCache = NSCache<NSURL, NSImage>()

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
            currentImage = NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "Lovely Pet")
            return
        }

        let frame = state.frames[min(frameIndex, state.frames.count - 1)]
        currentImage = loadImage(frame: frame)
            ?? NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "Lovely Pet")
    }

    private func loadImage(frame: String) -> NSImage? {
        guard let url = PetResourceLocator.imageURL(petID: manifest.id, relativePath: frame) else { return nil }
        let cacheKey = url as NSURL

        if let cachedImage = Self.decodedImageCache.object(forKey: cacheKey) {
            return cachedImage
        }

        let image: NSImage?
        if url.pathExtension.lowercased() == "b64" {
            image = Self.loadBase64EncodedImage(from: url)
        } else {
            image = NSImage(contentsOf: url)
        }

        if let image {
            Self.decodedImageCache.setObject(image, forKey: cacheKey)
        }
        return image
    }

    private static func loadBase64EncodedImage(from url: URL) -> NSImage? {
        guard
            let encoded = try? String(contentsOf: url, encoding: .utf8),
            let data = Data(base64Encoded: encoded, options: .ignoreUnknownCharacters)
        else {
            return nil
        }
        return NSImage(data: data)
    }
}
