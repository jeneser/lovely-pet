import SwiftUI

struct PetView: View {
    @ObservedObject var player: FrameAnimationPlayer
    @ObservedObject var settings: PetSettings
    @State private var hovering = false

    var body: some View {
        ProceduralRagdollCatView(hovering: hovering)
            .frame(width: 260 * settings.scale, height: 280 * settings.scale)
            .contentShape(Rectangle())
            .background(Color.clear)
            .onHover { value in
                hovering = value
                player.handleHover(value)
            }
            .onTapGesture {
                player.handleTap()
            }
    }
}
