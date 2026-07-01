import AppKit
import SwiftUI

final class PetWindowController: NSWindowController, NSWindowDelegate {
    let settings: PetSettings
    private let player: FrameAnimationPlayer
    private let xKey = "lovelyPet.demo.window.x"
    private let yKey = "lovelyPet.demo.window.y"
    private let defaultSize = NSSize(width: 340, height: 360)

    init(settings: PetSettings, player: FrameAnimationPlayer) {
        self.settings = settings
        self.player = player

        let contentView = PetView(player: player, settings: settings)
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor

        let origin = Self.savedOrigin(width: defaultSize.width, height: defaultSize.height)
        let window = NSPanel(
            contentRect: NSRect(origin: origin, size: defaultSize),
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
        savePosition()
    }

    func windowDidMove(_ notification: Notification) {
        savePosition()
    }

    private func savePosition() {
        guard let window else { return }
        UserDefaults.standard.set(window.frame.origin.x, forKey: xKey)
        UserDefaults.standard.set(window.frame.origin.y, forKey: yKey)
    }

    private static func savedOrigin(width: CGFloat, height: CGFloat) -> NSPoint {
        let defaults = UserDefaults.standard
        let x = defaults.double(forKey: "lovelyPet.demo.window.x")
        let y = defaults.double(forKey: "lovelyPet.demo.window.y")
        if x != 0 || y != 0 {
            return NSPoint(x: x, y: y)
        }
        return defaultOrigin(width: width, height: height)
    }

    private static func defaultOrigin(width: CGFloat, height: CGFloat) -> NSPoint {
        let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        return NSPoint(x: screen.maxX - width - 80, y: screen.minY + 80)
    }
}
