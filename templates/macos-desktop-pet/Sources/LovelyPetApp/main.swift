import AppKit
import SwiftUI

@main
final class LovelyPetApplication: NSObject, NSApplicationDelegate {
    private var windowController: PetWindowController?
    private var statusItem: NSStatusItem?
    private var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        let manifest = PetManifest.loadDefault()
        let settings = PetSettings(manifest: manifest)
        let player = FrameAnimationPlayer(manifest: manifest)

        windowController = PetWindowController(settings: settings, player: player)
        windowController?.showWindow(nil)

        setupStatusItem(settings: settings)
    }

    private func setupStatusItem(settings: PetSettings) {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.title = "🐾"

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        item.menu = menu
        statusItem = item
    }

    @objc private func openSettings() {
        let view = SettingsView()
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 360, height: 260), styleMask: [.titled, .closable], backing: .buffered, defer: false)
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
