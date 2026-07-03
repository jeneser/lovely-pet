import SwiftUI
import Combine

struct PetView: View {
    @ObservedObject var player: FrameAnimationPlayer
    @ObservedObject var settings: PetSettings
    @StateObject private var interaction = PetInteractionModel()

    private let idleTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        let baseSize = settings.baseWindowSize
        let scaledSize = settings.scaledWindowSize

        PetImageAssetView(player: player, interaction: interaction, canvasSize: baseSize)
            .frame(width: baseSize.width, height: baseSize.height)
            .scaleEffect(settings.scale, anchor: .center)
            .frame(width: scaledSize.width, height: scaledSize.height)
            .contentShape(Rectangle())
            .background(Color.clear)
            .onHover { value in
                interaction.setHovering(value)
                player.handleHover(value)
            }
            // onContinuousHover is macOS 13+; the modifier guards internally.
            .modifier(ContinuousHoverModifier(interaction: interaction, player: player, size: scaledSize))
            .gesture(
                TapGesture(count: 2)
                    .onEnded {
                        interaction.doubleTap()
                        player.handleTap()
                    }
                    .exclusively(before: TapGesture().onEnded {
                        interaction.tap()
                        player.handleTap()
                    })
            )
            .onLongPressGesture(minimumDuration: 0.45) {
                interaction.startDragging()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    interaction.endDragging()
                }
            }
            .frame(width: scaledSize.width, height: scaledSize.height)
            .background(Color.clear)
            .onReceive(idleTimer) { _ in
                interaction.maybeSleep()
                player.handleSleep(interaction.asleep)
            }
            // Use the macOS 12-compatible onChange(of:perform:) overload.
            .onChange(of: interaction.asleep, perform: { sleeping in
                player.handleSleep(sleeping)
            })
    }
}

// MARK: - Continuous Hover Compat

/// Applies continuous hover tracking on macOS 13+ and is a no-op on macOS 12.
private struct ContinuousHoverModifier: ViewModifier {
    let interaction: PetInteractionModel
    let player: FrameAnimationPlayer
    let size: CGSize

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(macOS 13, *) {
            content.onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    interaction.updatePointer(location: location, size: size)
                case .ended:
                    interaction.setHovering(false)
                    player.handleHover(false)
                }
            }
        } else {
            // macOS 12: gaze tracking unavailable, graceful degradation.
            content
        }
    }
}
