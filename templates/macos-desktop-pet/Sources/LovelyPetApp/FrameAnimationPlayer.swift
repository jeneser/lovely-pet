import AppKit
import Combine
import CoreVideo
import Foundation
import QuartzCore

final class FrameAnimationPlayer: ObservableObject {
    @Published private(set) var currentImage: NSImage?
    @Published private(set) var stateName: String

    private static let decodedImageCache = NSCache<NSURL, NSImage>()
    private static let displayLinkCallback: CVDisplayLinkOutputCallback = { _, _, _, _, _, context in
        guard let context else { return kCVReturnError }
        let player = Unmanaged<FrameAnimationPlayer>.fromOpaque(context).takeUnretainedValue()
        player.displayLinkDidFire()
        return kCVReturnSuccess
    }

    private let manifest: PetManifest
    private var displayLink: CVDisplayLink?
    private var frameIndex = 0
    private var activeFrames: [String] = []
    private var activeFPS = 12
    private var activeLoop = true
    private var activeNextState: String?
    private var isPlayingTransition = false
    private var pendingStateAfterTransition: String?
    private var targetFrameDuration: CFTimeInterval = 1.0 / 12.0
    private var lastFrameTime: CFTimeInterval = 0

    init(manifest: PetManifest) {
        self.manifest = manifest
        self.stateName = manifest.defaultState
        configureDisplayLink()
        startState(manifest.defaultState)
    }

    deinit {
        stopDisplayLink()
    }

    func play(state: String) {
        guard let targetState = manifest.states[state] else { return }

        if isPlayingTransition {
            pendingStateAfterTransition = state
            return
        }

        if state == stateName {
            if !targetState.loop {
                startState(state)
            }
            return
        }

        if let exitFrames = manifest.states[stateName]?.exitFrames, !exitFrames.isEmpty {
            startTransition(from: stateName, to: state, exitFrames: exitFrames)
            return
        }

        startState(state)
    }

    func playDefaultState() {
        play(state: manifest.defaultState)
    }

    func preloadAllFrames() {
        let frames = Set(manifest.states.values.flatMap { state in
            state.frames + (state.exitFrames ?? [])
        })

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            for frame in frames {
                _ = self.loadImage(frame: frame)
            }
        }
    }

    func handleHover(_ hovering: Bool) {
        let hoverState = manifest.behavior?.hoverState ?? "hover"
        if hovering, manifest.states[hoverState] != nil {
            play(state: hoverState)
        } else {
            playDefaultState()
        }
    }

    func handleTap() {
        let tapState = manifest.behavior?.tapState ?? "tap"
        if manifest.states[tapState] != nil {
            play(state: tapState)
        }
    }

    func handleSleep(_ sleeping: Bool) {
        let sleepState = manifest.behavior?.sleepState ?? "sleep"
        if sleeping, manifest.states[sleepState] != nil {
            play(state: sleepState)
        } else if stateName == sleepState {
            playDefaultState()
        }
    }

    private func configureDisplayLink() {
        var newDisplayLink: CVDisplayLink?
        let result = CVDisplayLinkCreateWithActiveCGDisplays(&newDisplayLink)
        guard result == kCVReturnSuccess, let newDisplayLink else { return }
        CVDisplayLinkSetOutputCallback(
            newDisplayLink,
            Self.displayLinkCallback,
            Unmanaged.passUnretained(self).toOpaque()
        )
        displayLink = newDisplayLink
    }

    private func startTransition(from currentState: String, to nextState: String, exitFrames: [String]) {
        stopDisplayLink()
        isPlayingTransition = true
        pendingStateAfterTransition = nextState
        activeFrames = exitFrames
        activeFPS = max(manifest.states[currentState]?.fps ?? manifest.states[nextState]?.fps ?? 12, 1)
        activeLoop = false
        activeNextState = nextState
        targetFrameDuration = 1.0 / Double(activeFPS)
        frameIndex = 0
        loadFrame()
        startDisplayLinkIfNeeded()
    }

    private func startState(_ state: String) {
        guard let stateConfig = manifest.states[state] else { return }
        stopDisplayLink()
        isPlayingTransition = false
        pendingStateAfterTransition = nil
        stateName = state
        activeFrames = stateConfig.frames
        activeFPS = max(stateConfig.fps, 1)
        activeLoop = stateConfig.loop
        activeNextState = stateConfig.nextState
        targetFrameDuration = 1.0 / Double(activeFPS)
        frameIndex = 0
        loadFrame()
        startDisplayLinkIfNeeded()
    }

    private func startDisplayLinkIfNeeded() {
        guard !activeFrames.isEmpty else { return }
        if activeLoop && activeFrames.count <= 1 { return }
        guard let displayLink else { return }
        lastFrameTime = CACurrentMediaTime()
        if !CVDisplayLinkIsRunning(displayLink) {
            CVDisplayLinkStart(displayLink)
        }
    }

    private func stopDisplayLink() {
        guard let displayLink, CVDisplayLinkIsRunning(displayLink) else { return }
        CVDisplayLinkStop(displayLink)
    }

    private func displayLinkDidFire() {
        let now = CACurrentMediaTime()
        DispatchQueue.main.async { [weak self] in
            self?.tick(now: now)
        }
    }

    private func tick(now: CFTimeInterval) {
        guard !activeFrames.isEmpty else { return }
        guard now - lastFrameTime >= targetFrameDuration else { return }
        lastFrameTime = now
        advance()
    }

    private func advance() {
        frameIndex += 1
        if frameIndex >= activeFrames.count {
            if activeLoop {
                frameIndex = 0
            } else {
                let nextState = pendingStateAfterTransition ?? activeNextState ?? manifest.defaultState
                startState(nextState)
                return
            }
        }
        loadFrame()
    }

    private func loadFrame() {
        guard !activeFrames.isEmpty else {
            currentImage = NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "Lovely Pet")
            return
        }

        let frame = activeFrames[min(frameIndex, activeFrames.count - 1)]
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
