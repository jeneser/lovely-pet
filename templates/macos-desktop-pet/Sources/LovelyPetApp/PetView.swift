import SwiftUI

struct PetView: View {
    @ObservedObject var player: FrameAnimationPlayer
    @ObservedObject var settings: PetSettings

    var body: some View {
        ZStack {
            if let image = player.currentImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220 * settings.scale, height: 220 * settings.scale)
                    .onHover { hovering in
                        player.handleHover(hovering)
                    }
                    .onTapGesture {
                        player.handleTap()
                    }
            } else {
                Text("🐾")
                    .font(.system(size: 96))
            }
        }
        .frame(width: 260 * settings.scale, height: 260 * settings.scale)
        .background(Color.clear)
    }
}
