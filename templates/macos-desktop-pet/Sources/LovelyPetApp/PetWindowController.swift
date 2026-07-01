import AppKit
import SwiftUI

final class PetWindowController: NSWindowController, NSWindowDelegate {
    let settings: PetSettings
    private let player: FrameAnimationPlayer

    init(settings: PetSettings, player: FrameAnimationPlayer) {
        self.settings = settings
        self.player = player

        let contentView = PetView(player: player, settings: settings)
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor

        let size = NSSize(width: 340, height: 360)
        let origin = Self.savedOrigin(width: size.width, height: size.height)
        let window = NSPanel(
            contentRect: NSRect(origin: origin, size: size),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.contentView = hostingView
        window.isMovableByWindowBackground = true

        super.init(window: window)
        window.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetPosition() {
        guard let window else { return }
        window.setFrameOrigin(Self.defaultOrigin(width: window.frame.width, height: window.frame.height))
        window.orderFrontRegardless()
        savePosition()
    }

    func showPet() {
        guard let window else { return }
        let origin = Self.visibleOrigin(for: window.frame)
        if origin != window.frame.origin {
            window.setFrameOrigin(origin)
            savePosition()
        }
        window.orderFrontRegardless()
    }

    func windowDidMove(_ notification: Notification) {
        savePosition()
    }

    private func savePosition() {
        guard let window else { return }
        UserDefaults.standard.set(window.frame.origin.x, forKey: LocalStorageKeys.windowX)
        UserDefaults.standard.set(window.frame.origin.y, forKey: LocalStorageKeys.windowY)
    }

    private static func savedOrigin(width: CGFloat, height: CGFloat) -> NSPoint {
        let defaults = UserDefaults.standard
        let x = defaults.double(forKey: LocalStorageKeys.windowX)
        let y = defaults.double(forKey: LocalStorageKeys.windowY)
        if x != 0 || y != 0 {
            let frame = NSRect(x: x, y: y, width: width, height: height)
            return visibleOrigin(for: frame)
        }
        return defaultOrigin(width: width, height: height)
    }

    private static func defaultOrigin(width: CGFloat, height: CGFloat) -> NSPoint {
        let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        return NSPoint(x: screen.maxX - width - 80, y: screen.minY + 80)
    }

    private static func visibleOrigin(for frame: NSRect) -> NSPoint {
        let visibleFrames = NSScreen.screens.map(\.visibleFrame)
        if visibleFrames.contains(where: { $0.intersects(frame) }) {
            return frame.origin
        }
        return defaultOrigin(width: frame.width, height: frame.height)
    }
}
