import AppKit
import Foundation

final class FrameAnimationPlayer: ObservableObject {
    @Published private(set) var currentImage: NSImage?
    @Published private(set) var stateName: String

    private let manifest: PetManifest
    private var timer: Timer?
    private var frameIndex = 0

    init(manifest: PetManifest) {
        self.manifest = manifest
        self.stateName = manifest.defaultState
        loadFrame()
        play(state: manifest.defaultState)
    }

    func play(state: String) {
        guard manifest.states[state] != nil else { return }
        timer?.invalidate()
        stateName = state
        frameIndex = 0
        loadFrame()

        let fps = manifest.states[state]?.fps ?? 12
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
        let resourcePath = "Resources/pets/\(manifest.id)/\(frame)"
        currentImage = Bundle.module.image(forResource: resourcePath) ?? NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "Lovely Pet")
    }
}
