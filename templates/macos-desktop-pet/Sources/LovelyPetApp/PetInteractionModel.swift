import Foundation
import CoreGraphics
import Combine

final class PetInteractionModel: ObservableObject {
    @Published var hovering = false
    @Published var tapping = false
    @Published var celebrating = false
    @Published var celebrationStartedAt = Date.distantPast
    @Published var asleep = false
    @Published var dragging = false
    @Published var gazeX: Double = 0
    @Published var gazeY: Double = 0
    @Published var message: String? = nil
    @Published var touchedZone: String? = nil

    private var lastInteractionAt = Date()
    private var lastPointerLocation: CGPoint?
    private var lastPointerSize: CGSize?
    private var resetObserver: NSObjectProtocol?

    init() {
        resetObserver = NotificationCenter.default.addObserver(forName: .lovelyPetResetLocalData, object: nil, queue: .main) { [weak self] _ in
            self?.resetInMemoryState()
        }
    }

    deinit {
        if let resetObserver { NotificationCenter.default.removeObserver(resetObserver) }
    }

    var mood: String {
        if asleep { return "sleepy" }
        if dragging { return "startled" }
        if celebrating { return "happy" }
        if hovering { return "curious" }
        return "calm"
    }

    func setHovering(_ value: Bool) {
        hovering = value
        if value { wake(reason: nil) }
        if !value {
            gazeX = 0
            gazeY = 0
        }
    }

    func updatePointer(location: CGPoint, size: CGSize) {
        guard size.width > 0, size.height > 0 else { return }
        lastPointerLocation = location
        lastPointerSize = size
        let normalizedX = Double((location.x / size.width - 0.5) * 2)
        let normalizedY = Double((0.5 - location.y / size.height) * 2)
        gazeX = max(-1, min(1, normalizedX))
        gazeY = max(-1, min(1, normalizedY))
        lastInteractionAt = Date()
    }

    func tap() {
        if let location = lastPointerLocation, let size = lastPointerSize {
            tap(at: location, size: size)
        } else {
            react(zone: nil, fallbackMessage: nil)
        }
    }

    func tap(at location: CGPoint, size: CGSize) {
        let zone = classify(location: location, size: size)
        switch zone {
        case "head":
            react(zone: zone, fallbackMessage: nil)
        case "tail":
            react(zone: zone, fallbackMessage: "尾巴！")
        case "paw":
            react(zone: zone, fallbackMessage: "握爪")
        default:
            react(zone: zone, fallbackMessage: nil)
        }
    }

    func doubleTap() {
        wake(reason: nil)
        celebrating = true
        celebrationStartedAt = Date()
        message = nil
        touchedZone = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) { [weak self] in
            self?.celebrating = false
        }
    }

    func startDragging() {
        wake(reason: nil)
        dragging = true
    }

    func endDragging() {
        dragging = false
        message = nil
    }

    func maybeSleep() {
        if Date().timeIntervalSince(lastInteractionAt) > 60 {
            asleep = true
            hovering = false
            gazeX = 0
            gazeY = 0
        }
    }

    private func react(zone: String?, fallbackMessage: String?) {
        wake(reason: nil)
        tapping = true
        touchedZone = zone
        message = fallbackMessage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) { [weak self] in
            self?.tapping = false
            self?.touchedZone = nil
            self?.message = nil
        }
    }

    private func classify(location: CGPoint, size: CGSize) -> String {
        guard size.width > 0, size.height > 0 else { return "body" }
        let x = location.x / size.width
        let y = location.y / size.height
        if y < 0.38 { return "head" }
        if x < 0.30 && y > 0.45 { return "tail" }
        if y > 0.72 { return "paw" }
        return "body"
    }

    private func wake(reason: String?) {
        asleep = false
        lastInteractionAt = Date()
        if let reason { message = reason }
    }

    private func resetInMemoryState() {
        hovering = false
        tapping = false
        celebrating = false
        dragging = false
        asleep = false
        gazeX = 0
        gazeY = 0
        message = nil
        touchedZone = nil
        celebrationStartedAt = Date.distantPast
        lastInteractionAt = Date()
    }
}
