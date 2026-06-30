import SwiftUI
import Combine

struct PetView: View {
    @ObservedObject var player: FrameAnimationPlayer
    @ObservedObject var settings: PetSettings
    @StateObject private var interaction = PetInteractionModel()

    private let idleTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { proxy in
            ProceduralRagdollCatView(interaction: interaction)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .contentShape(Rectangle())
                .background(Color.clear)
                .onHover { value in
                    interaction.setHovering(value)
                    player.handleHover(value)
                }
                .onContinuousHover { phase in
                    switch phase {
                    case .active(let location):
                        interaction.updatePointer(location: location, size: proxy.size)
                    case .ended:
                        interaction.setHovering(false)
                        player.handleHover(false)
                    }
                }
                .onTapGesture(count: 2) {
                    interaction.doubleTap()
                    player.handleTap()
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            interaction.updatePointer(location: value.location, size: proxy.size)
                            let dx = value.location.x - value.startLocation.x
                            let dy = value.location.y - value.startLocation.y
                            if abs(dx) + abs(dy) > 8 {
                                interaction.startDragging()
                            }
                        }
                        .onEnded { value in
                            let dx = value.location.x - value.startLocation.x
                            let dy = value.location.y - value.startLocation.y
                            if abs(dx) + abs(dy) > 8 {
                                interaction.endDragging()
                            } else {
                                interaction.tap(at: value.location, size: proxy.size)
                                player.handleTap()
                            }
                        }
                )
        }
        .frame(width: 300 * settings.scale, height: 320 * settings.scale)
        .background(Color.clear)
        .onReceive(idleTimer) { _ in
            interaction.maybeSleep()
        }
    }
}
