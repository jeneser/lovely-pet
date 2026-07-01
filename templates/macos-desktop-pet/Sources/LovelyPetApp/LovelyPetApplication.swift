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
        let item = NSStatusBar.system.statusItem(withLength: 128)
        item.isVisible = true
        item.button?.title = "Lovely Pet 🐾"
        item.button?.toolTip = "Lovely Pet is running"

        let menu = NSMenu()
        menu.addItem(menuItem(title: "Show Pet", action: #selector(showPet)))
        menu.addItem(menuItem(title: "Reset Position", action: #selector(resetPosition), keyEquivalent: "r"))
        menu.addItem(menuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(.separator())
        menu.addItem(menuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        item.menu = menu
        statusItem = item
    }

    private func menuItem(title: String, action: Selector, keyEquivalent: String = "") -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        item.target = self
        return item
    }

    @objc private func showPet() {
        windowController?.showPet()
    }

    @objc private func resetPosition() {
        windowController?.resetPosition()
    }

    @objc private func openSettings() {
        guard let settings = windowController?.settings else { return }
        let view = SettingsView(settings: settings)
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 420, height: 340), styleMask: [.titled, .closable], backing: .buffered, defer: false)
        window.center()
        window.title = "Lovely Pet Settings"
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        settingsWindow = window
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
