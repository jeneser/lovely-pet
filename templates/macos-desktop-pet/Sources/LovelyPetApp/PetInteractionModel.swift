import Foundation
import CoreGraphics
import Combine

final class PetInteractionModel: ObservableObject {
    @Published var hovering = false
    @Published var tapping = false
    @Published var celebrating = false
    @Published var asleep = false
    @Published var affection = 0
    @Published var gazeX: Double = 0
    @Published var gazeY: Double = 0
    @Published var message: String? = nil

    private var lastInteractionAt = Date()

    var mood: String {
        if asleep { return "sleepy" }
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
        let normalizedX = Double((location.x / size.width - 0.5) * 2)
        let normalizedY = Double((0.5 - location.y / size.height) * 2)
        gazeX = max(-1, min(1, normalizedX))
        gazeY = max(-1, min(1, normalizedY))
        lastInteractionAt = Date()
    }

    func tap() {
        wake(reason: nil)
        affection = min(99, affection + 1)
        tapping = true
        message = affection % 5 == 0 ? "喵～" : nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) { [weak self] in
            self?.tapping = false
            self?.message = nil
        }
    }

    func doubleTap() {
        wake(reason: "喜欢你")
        affection = min(99, affection + 3)
        celebrating = true
        message = "喜欢你"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.celebrating = false
            self?.message = nil
        }
    }

    func maybeSleep() {
        if Date().timeIntervalSince(lastInteractionAt) > 60 {
            asleep = true
            hovering = false
            gazeX = 0
            gazeY = 0
        }
    }

    private func wake(reason: String?) {
        asleep = false
        lastInteractionAt = Date()
        if let reason { message = reason }
    }
}
