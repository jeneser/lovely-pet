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
                // onContinuousHover is macOS 13+; the modifier guards internally
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
        // The two-argument { old, new in } form of onChange is macOS 14+ only.
        // Use the single-argument perform: label overload which is available on macOS 12+.
        .onChange(of: interaction.asleep, perform: { sleeping in
            player.handleSleep(sleeping)
        })
    }
}

// MARK: - Continuous Hover Compat

/// Applies `onContinuousHover` on macOS 13+ and is a no-op on macOS 12.
private struct ContinuousHoverModifier: ViewModifier {
    let interaction: PetInteractionModel
    let player: FrameAnimationPlayer
    let proxy: GeometryProxy

    @ViewBuilder
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
            // macOS 12: gaze tracking unavailable, graceful degradation
            content
        }
    }
}
