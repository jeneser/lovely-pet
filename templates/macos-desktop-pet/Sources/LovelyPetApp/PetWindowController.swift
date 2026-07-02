import AppKit
import CoreGraphics
import SwiftUI

final class PetWindowController: NSWindowController, NSWindowDelegate {
    let settings: PetSettings
    private let player: FrameAnimationPlayer
    private var walkTimer: Timer?
    private var walkDirection: CGFloat = 1
    private var isDockWalking = false

    init(settings: PetSettings, player: FrameAnimationPlayer) {
        self.settings = settings
        self.player = player

        let contentView = PetView(player: player, settings: settings)
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor

        let manifestSize = Self.manifestWindowSize(settings.manifest)
        let origin = Self.savedOrigin(width: manifestSize.width, height: manifestSize.height)
        let window = NSPanel(
            contentRect: NSRect(origin: origin, size: manifestSize),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.dockWindow)) + 1)
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
        stopDockWalk()
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

    func toggleDockWalk() {
        isDockWalking ? stopDockWalk() : startDockWalk()
    }

    func windowDidMove(_ notification: Notification) {
        if !isDockWalking { savePosition() }
    }

    private func startDockWalk() {
        guard let window, let path = Self.dockWalkingPath(windowSize: window.frame.size) else { return }
        isDockWalking = true
        walkDirection = 1
        window.setFrameOrigin(NSPoint(x: path.minX, y: path.y))
        player.play(state: "walk_right")
        walkTimer?.invalidate()
        walkTimer = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.advanceDockWalk()
        }
        RunLoop.main.add(walkTimer!, forMode: .common)
    }

    private func stopDockWalk() {
        isDockWalking = false
        walkTimer?.invalidate()
        walkTimer = nil
        player.playDefaultState()
        savePosition()
    }

    private func advanceDockWalk() {
        guard let window, let path = Self.dockWalkingPath(windowSize: window.frame.size) else { return }
        var origin = window.frame.origin
        origin.x += walkDirection * 1.5
        origin.y = path.y
        if origin.x >= path.maxX {
            origin.x = path.maxX
            walkDirection = -1
            player.play(state: "walk_left")
        } else if origin.x <= path.minX {
            origin.x = path.minX
            walkDirection = 1
            player.play(state: "walk_right")
        }
        window.setFrameOrigin(origin)
    }

    private func savePosition() {
        guard let window else { return }
        UserDefaults.standard.set(window.frame.origin.x, forKey: LocalStorageKeys.windowX)
        UserDefaults.standard.set(window.frame.origin.y, forKey: LocalStorageKeys.windowY)
    }

    private static func manifestWindowSize(_ manifest: PetManifest) -> NSSize {
        if let window = manifest.window {
            return NSSize(width: CGFloat(window.width), height: CGFloat(window.height))
        }
        return NSSize(width: 340, height: 360)
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

    private static func dockFrame() -> NSRect? {
        guard let screen = NSScreen.main else { return nil }
        let full = screen.frame
        let visible = screen.visibleFrame
        if visible.minY > full.minY {
            return NSRect(x: full.minX, y: full.minY, width: full.width, height: visible.minY - full.minY)
        }
        return nil
    }

    private static func dockWalkingPath(windowSize: NSSize) -> (minX: CGFloat, maxX: CGFloat, y: CGFloat)? {
        guard let screen = NSScreen.main else { return nil }
        let dock = dockFrame()
        let y = (dock?.maxY ?? screen.visibleFrame.minY) - 18
        let minX = screen.visibleFrame.minX + 40
        let maxX = screen.visibleFrame.maxX - windowSize.width - 40
        guard maxX > minX else { return nil }
        return (minX, maxX, y)
    }
}
