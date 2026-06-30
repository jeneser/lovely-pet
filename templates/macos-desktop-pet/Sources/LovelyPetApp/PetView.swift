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
                .onTapGesture {
                    interaction.tap()
                    player.handleTap()
                }
        }
        .frame(width: 300 * settings.scale, height: 320 * settings.scale)
        .background(Color.clear)
        .onReceive(idleTimer) { _ in
            interaction.maybeSleep()
        }
    }
}
