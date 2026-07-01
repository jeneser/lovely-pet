import SwiftUI
import Foundation

struct PetImageAssetView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ObservedObject var player: FrameAnimationPlayer
    @ObservedObject var interaction: PetInteractionModel

    var body: some View {
        TimelineView(.periodic(from: .now, by: reduceMotion ? 1.0 : 1.0 / 24.0)) { timeline in
            let phase = timeline.date.timeIntervalSinceReferenceDate
            let sleeping = player.stateName == "sleep" || interaction.asleep
            let breath = reduceMotion ? 0 : CGFloat(sin(phase * (sleeping ? 1.1 : 2.1)))
            let hoverLift: CGFloat = interaction.hovering ? -8 : 0
            let tapLift: CGFloat = interaction.tapping ? -18 : 0
            let dragLift: CGFloat = interaction.dragging ? -12 : 0

            ZStack {
                groundShadow(sleeping: sleeping, breath: breath)
                petSprite(sleeping: sleeping, breath: breath)
                    .offset(y: hoverLift + tapLift + dragLift)

                if interaction.tapping { tapSparkles }
                if interaction.dragging { dragFeedback }
                if interaction.celebrating { hearts }
                if let zone = interaction.touchedZone { touchFeedback(zone) }
                if let message = interaction.message { messageBubble(message) }
                affectionBadge
            }
            .frame(width: 280, height: 310)
            .animation(.spring(response: 0.28, dampingFraction: 0.72), value: interaction.hovering)
            .animation(.spring(response: 0.22, dampingFraction: 0.48), value: interaction.tapping)
            .animation(.spring(response: 0.36, dampingFraction: 0.55), value: interaction.celebrating)
            .animation(.spring(response: 0.18, dampingFraction: 0.45), value: interaction.dragging)
            .animation(.spring(response: 0.30, dampingFraction: 0.76), value: player.stateName)
            .accessibilityLabel("Lovely photo based desktop pet")
        }
    }

    private func petSprite(sleeping: Bool, breath: CGFloat) -> some View {
        let size = spriteSize(sleeping: sleeping)
        let breathingScale = reduceMotion ? 1.0 : 1.0 + CGFloat(abs(breath)) * (sleeping ? 0.006 : 0.012)
        let interactionScale = interaction.dragging ? 0.96 : (interaction.tapping ? 1.08 : (interaction.hovering ? 1.04 : 1.0))
        let gazeOffset = CGSize(width: interaction.hovering ? CGFloat(interaction.gazeX) * 8 : 0,
                                height: interaction.hovering ? -CGFloat(interaction.gazeY) * 5 : 0)
        let rotation = interaction.dragging ? Double(interaction.gazeX * 8) : (interaction.tapping ? -4 : (interaction.hovering ? Double(interaction.gazeX * 3) : 0))

        return Group {
            if let image = player.currentImage {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
            } else {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 120, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: size.width, height: size.height)
        .scaleEffect(breathingScale * interactionScale, anchor: .bottom)
        .offset(x: gazeOffset.width, y: gazeOffset.height + (sleeping ? 36 : 0))
        .rotationEffect(.degrees(rotation), anchor: .bottom)
        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
    }

    private func spriteSize(sleeping: Bool) -> CGSize {
        sleeping ? CGSize(width: 300, height: 190) : CGSize(width: 250, height: 300)
    }

    private func groundShadow(sleeping: Bool, breath: CGFloat) -> some View {
        Ellipse()
            .fill(Color.black.opacity(interaction.dragging ? 0.08 : 0.14))
            .frame(width: sleeping ? 210 + breath * 2 : 156 + breath * 2, height: sleeping ? 18 : 24)
            .offset(y: sleeping ? 142 : 150)
            .blur(radius: 4)
    }

    private var tapSparkles: some View {
        ZStack {
            Circle().fill(Color.yellow.opacity(0.85)).frame(width: 8, height: 8).offset(x: -44, y: -126)
            Circle().fill(Color.yellow.opacity(0.65)).frame(width: 6, height: 6).offset(x: 118, y: -106)
            Circle().fill(Color.yellow.opacity(0.75)).frame(width: 5, height: 5).offset(x: 104, y: -32)
        }
    }

    private var dragFeedback: some View {
        ZStack {
            Text("!").font(.system(size: 28, weight: .bold)).foregroundStyle(.orange).offset(x: 104, y: -136)
            Circle().fill(Color.orange.opacity(0.75)).frame(width: 5, height: 5).offset(x: -48, y: -122)
        }
    }

    @ViewBuilder private func touchFeedback(_ zone: String) -> some View {
        switch zone {
        case "head":
            Text("♡").font(.system(size: 24, weight: .bold)).foregroundStyle(.pink).offset(x: 42, y: -136)
        case "tail":
            Text("!").font(.system(size: 24, weight: .bold)).foregroundStyle(.orange).offset(x: -120, y: 28)
        case "paw":
            Text("♡").font(.system(size: 18, weight: .bold)).foregroundStyle(.pink).offset(x: 48, y: 130)
        default:
            Text("♡").font(.system(size: 18, weight: .bold)).foregroundStyle(.pink.opacity(0.75)).offset(x: -12, y: 18)
        }
    }

    private var hearts: some View {
        ZStack {
            Text("♥").font(.system(size: 22)).foregroundStyle(.pink).offset(x: -60, y: -136)
            Text("♥").font(.system(size: 18)).foregroundStyle(.pink.opacity(0.8)).offset(x: 112, y: -126)
            Text("♥").font(.system(size: 14)).foregroundStyle(.pink.opacity(0.7)).offset(x: 132, y: -70)
        }
    }

    private func messageBubble(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.white.opacity(0.92))
            .clipShape(Capsule())
            .shadow(radius: 2)
            .offset(x: 72, y: -152)
    }

    private var affectionBadge: some View {
        Text("♡ \(interaction.affection)")
            .font(.system(size: 12, weight: .medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.white.opacity(0.65))
            .clipShape(Capsule())
            .offset(x: -96, y: -142)
            .opacity(interaction.affection > 0 ? 1 : 0)
    }
}
