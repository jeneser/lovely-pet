import AppKit
import SwiftUI

final class PetWindowController: NSWindowController {
    private let settings: PetSettings
    private let player: FrameAnimationPlayer

    init(settings: PetSettings, player: FrameAnimationPlayer) {
        self.settings = settings
        self.player = player

        let contentView = PetView(player: player, settings: settings)
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor

        let window = NSPanel(
            contentRect: NSRect(x: 1200, y: 120, width: 280, height: 280),
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
