import Foundation
import CoreGraphics
import Combine

final class PetInteractionModel: ObservableObject {
    @Published var hovering = false
    @Published var tapping = false
    @Published var celebrating = false
    @Published var asleep = false
    @Published var dragging = false
    @Published var affection = 0
    @Published var gazeX: Double = 0
    @Published var gazeY: Double = 0
    @Published var message: String? = nil
    @Published var touchedZone: String? = nil

    private let affectionKey = "lovelyPet.demo.affection"
    private var lastInteractionAt = Date()
    private var lastPointerLocation: CGPoint?
    private var lastPointerSize: CGSize?

    init() {
        affection = UserDefaults.standard.integer(forKey: affectionKey)
    }

    var mood: String {
        if asleep { return "sleepy" }
        if dragging { return "startled" }
        if celebrating { return "happy" }
        if hovering { return "curious" }
        return affection >= 8 ? "trusting" : "calm"
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
            react(zone: nil, affectionGain: 1, fallbackMessage: affection % 5 == 4 ? "喵～" : nil)
        }
    }

    func tap(at location: CGPoint, size: CGSize) {
        let zone = classify(location: location, size: size)
        switch zone {
        case "head":
            react(zone: zone, affectionGain: 2, fallbackMessage: "摸摸头")
        case "tail":
            react(zone: zone, affectionGain: 1, fallbackMessage: "尾巴！")
        case "paw":
            react(zone: zone, affectionGain: 2, fallbackMessage: "握爪")
        default:
            react(zone: zone, affectionGain: 1, fallbackMessage: affection % 5 == 4 ? "呼噜～" : nil)
        }
    }

    func doubleTap() {
        wake(reason: "喜欢你")
        affection = min(99, affection + 3)
        persistAffection()
        celebrating = true
        message = "喜欢你"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.celebrating = false
            self?.message = nil
        }
    }

    func startDragging() {
        wake(reason: "放我下来")
        dragging = true
    }

    func endDragging() {
        dragging = false
        message = nil
        affection = min(99, affection + 1)
        persistAffection()
    }

    func maybeSleep() {
        if Date().timeIntervalSince(lastInteractionAt) > 60 {
            asleep = true
            hovering = false
            gazeX = 0
            gazeY = 0
        }
    }

    private func react(zone: String?, affectionGain: Int, fallbackMessage: String?) {
        wake(reason: nil)
        affection = min(99, affection + affectionGain)
        persistAffection()
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

    private func persistAffection() {
        UserDefaults.standard.set(affection, forKey: affectionKey)
    }
}
