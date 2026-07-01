import SwiftUI
import Combine

struct PetView: View {
    @ObservedObject var player: FrameAnimationPlayer
    @ObservedObject var settings: PetSettings
    @StateObject private var interaction = PetInteractionModel()

    private let idleTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { proxy in
            PetImageAssetView(player: player, interaction: interaction)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .contentShape(Rectangle())
                .background(Color.clear)
                .onHover { value in
                    interaction.setHovering(value)
                    player.handleHover(value)
                }
                // onContinuousHover requires macOS 13+; fall back to onHover on macOS 12
                .modifier(ContinuousHoverModifier(interaction: interaction, player: player, proxy: proxy))
                .onTapGesture(count: 2) {
                    interaction.doubleTap()
                    player.handleTap()
                }
                .onTapGesture {
                    interaction.tap()
                    player.handleTap()
                }
                .onLongPressGesture(minimumDuration: 0.45) {
                    interaction.startDragging()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        interaction.endDragging()
                    }
                }
        }
        .frame(width: 300 * settings.scale, height: 320 * settings.scale)
        .background(Color.clear)
        .onReceive(idleTimer) { _ in
            interaction.maybeSleep()
            player.handleSleep(interaction.asleep)
        }
        // onChange(of:) with single new-value closure requires macOS 14+
        // Use the two-argument form (oldValue, newValue) which is available on macOS 12+
        .onChange(of: interaction.asleep) { _, sleeping in
            player.handleSleep(sleeping)
        }
    }
}

// MARK: - Continuous Hover Compat

/// Wraps `onContinuousHover` (macOS 13+) and silently does nothing on macOS 12.
private struct ContinuousHoverModifier: ViewModifier {
    let interaction: PetInteractionModel
    let player: FrameAnimationPlayer
    let proxy: GeometryProxy

    func body(content: Content) -> some View {
        if #available(macOS 13, *) {
            content.onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    interaction.updatePointer(location: location, size: proxy.size)
                case .ended:
                    interaction.setHovering(false)
                    player.handleHover(false)
                }
            }
        } else {
            // macOS 12: gaze tracking not available, graceful degradation
            content
        }
    }
}
