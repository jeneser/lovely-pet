import SwiftUI

struct PetView: View {
    @ObservedObject var player: FrameAnimationPlayer
    @ObservedObject var settings: PetSettings
    @State private var hovering = false
    @State private var tapping = false

    var body: some View {
        ProceduralRagdollCatView(hovering: hovering, tapping: tapping)
            .frame(width: 260 * settings.scale, height: 280 * settings.scale)
            .contentShape(Rectangle())
            .background(Color.clear)
            .onHover { value in
                hovering = value
                player.handleHover(value)
            }
            .onTapGesture {
                tapping = true
                player.handleTap()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    tapping = false
                }
            }
    }
}
