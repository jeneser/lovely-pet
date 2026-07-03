import AppKit
import SwiftUI

@main
final class LovelyPetApplication: NSObject, NSApplicationDelegate {
    private static var retainedDelegate: LovelyPetApplication?

    static func main() {
        let app = NSApplication.shared
        let delegate = LovelyPetApplication()
        retainedDelegate = delegate
        app.delegate = delegate
        app.run()
    }

    private var windowController: PetWindowController?
    private var statusItem: NSStatusItem?
    private var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupStatusItem()

        let manifest = PetManifest.loadDefault()
        let settings = PetSettings(manifest: manifest)
        let player = FrameAnimationPlayer(manifest: manifest)

        windowController = PetWindowController(settings: settings, player: player)
        windowController?.showPet()
    }

    private func setupStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.isVisible = true
        configureStatusButton(item.button)

        let menu = NSMenu()
        menu.addItem(menuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ",", systemImageName: "gearshape"))
        menu.addItem(.separator())
        menu.addItem(menuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q", systemImageName: "power"))
        item.menu = menu
        statusItem = item
    }

    private func configureStatusButton(_ button: NSStatusBarButton?) {
        guard let button else { return }
        button.title = ""
        button.toolTip = "Pet controls"

        if let image = NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "Pet controls") {
            image.isTemplate = true
            button.image = image
            button.imagePosition = .imageOnly
        } else {
            button.title = "🐾"
        }
    }

    private func menuItem(title: String, action: Selector, keyEquivalent: String = "", systemImageName: String? = nil) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        item.target = self
        if let systemImageName = systemImageName, let image = NSImage(systemSymbolName: systemImageName, accessibilityDescription: title) {
            image.isTemplate = true
            item.image = image
        }
        return item
    }

    @objc private func openSettings() {
        guard let settings = windowController?.settings else { return }
        let view = SettingsView(settings: settings)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 520),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Lovely Pet Settings"
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        settingsWindow = window
        // NSApp.activate(ignoringOtherApps:) is deprecated in macOS 14+
        // Use the new activate() API on macOS 14+ and fall back on older systems
        if #available(macOS 14, *) {
            NSApp.activate()
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
