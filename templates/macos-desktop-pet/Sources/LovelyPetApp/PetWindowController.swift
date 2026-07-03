import AppKit
import Combine
import SwiftUI

final class PetWindowController: NSWindowController, NSWindowDelegate {
    let settings: PetSettings
    private let player: FrameAnimationPlayer
    private var scaleCancellable: AnyCancellable?

    init(settings: PetSettings, player: FrameAnimationPlayer) {
        self.settings = settings
        self.player = player

        let contentView = PetView(player: player, settings: settings)
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor

        let size = settings.scaledWindowSize
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

        scaleCancellable = settings.$scale
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] _ in
                self?.applyScaleToWindow()
            }
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
        let visibleFrame = Self.visibleFrame(for: window.frame)
        if visibleFrame.origin != window.frame.origin {
            window.setFrame(visibleFrame, display: true, animate: false)
            savePosition()
        }
        window.orderFrontRegardless()
    }

    func windowDidMove(_ notification: Notification) {
        savePosition()
    }

    private func applyScaleToWindow() {
        guard let window else { return }
        let oldFrame = window.frame
        let newSize = settings.scaledWindowSize
        let anchoredOrigin = Self.resizedOrigin(from: oldFrame, newSize: newSize, anchor: settings.manifest.anchor)
        let resizedFrame = NSRect(origin: anchoredOrigin, size: newSize)
        window.setFrame(Self.visibleFrame(for: resizedFrame), display: true, animate: false)
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

    private static func resizedOrigin(from oldFrame: NSRect, newSize: NSSize, anchor: String) -> NSPoint {
        switch anchor {
        case "bottom-right":
            return NSPoint(x: oldFrame.maxX - newSize.width, y: oldFrame.minY)
        case "bottom-left":
            return oldFrame.origin
        case "top-right":
            return NSPoint(x: oldFrame.maxX - newSize.width, y: oldFrame.maxY - newSize.height)
        case "top-left":
            return NSPoint(x: oldFrame.minX, y: oldFrame.maxY - newSize.height)
        default:
            return NSPoint(x: oldFrame.midX - newSize.width / 2, y: oldFrame.midY - newSize.height / 2)
        }
    }

    private static func visibleOrigin(for frame: NSRect) -> NSPoint {
        visibleFrame(for: frame).origin
    }

    private static func visibleFrame(for frame: NSRect) -> NSRect {
        let fallback = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        let visibleFrames = NSScreen.screens.map(\.visibleFrame)
        let target = visibleFrames.first(where: { $0.intersects(frame) }) ?? fallback
        let maxX = max(target.minX, target.maxX - frame.width)
        let maxY = max(target.minY, target.maxY - frame.height)
        let x = min(max(frame.origin.x, target.minX), maxX)
        let y = min(max(frame.origin.y, target.minY), maxY)
        return NSRect(x: x, y: y, width: frame.width, height: frame.height)
    }
}
