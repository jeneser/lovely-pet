import SwiftUI
import Foundation

struct PetImageAssetView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ObservedObject var player: FrameAnimationPlayer
    @ObservedObject var interaction: PetInteractionModel
    let canvasSize: CGSize

    var body: some View {
        TimelineView(.periodic(from: .now, by: reduceMotion ? 1.0 : 1.0 / 24.0)) { timeline in
            let phase = timeline.date.timeIntervalSinceReferenceDate
            let sleeping = player.stateName == "sleep" || interaction.asleep
            let breath = reduceMotion ? 0 : CGFloat(sin(phase * (sleeping ? 1.1 : 2.1)))
            let hoverLift: CGFloat = interaction.hovering ? -8 : 0
            let tapLift: CGFloat = interaction.tapping ? -18 : 0
            let dragLift: CGFloat = interaction.dragging ? -12 : 0
            let celebrationProgress = celebrationProgress(at: timeline.date)

            ZStack {
                groundShadow(sleeping: sleeping, breath: breath)
                petSprite(breath: breath)
                    .offset(y: hoverLift + tapLift + dragLift)

                if interaction.tapping { tapSparkles }
                if interaction.dragging { dragFeedback }
                if interaction.celebrating { hearts(progress: celebrationProgress) }
                if let zone = interaction.touchedZone { touchFeedback(zone) }
                if let message = interaction.message { messageBubble(message) }
            }
            .frame(width: canvasSize.width, height: canvasSize.height)
            .animation(.spring(response: 0.28, dampingFraction: 0.72), value: interaction.hovering)
            .animation(.spring(response: 0.22, dampingFraction: 0.48), value: interaction.tapping)
            .animation(.spring(response: 0.36, dampingFraction: 0.55), value: interaction.celebrating)
            .animation(.spring(response: 0.18, dampingFraction: 0.45), value: interaction.dragging)
            .animation(.spring(response: 0.30, dampingFraction: 0.76), value: player.stateName)
            .accessibilityLabel("Lovely PNG frame desktop pet")
        }
    }

    private func petSprite(breath: CGFloat) -> some View {
        let breathingScale = reduceMotion ? 1.0 : 1.0 + CGFloat(abs(breath)) * 0.010
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
                Color.clear
            }
        }
        .frame(width: canvasSize.width, height: canvasSize.height)
        .scaleEffect(breathingScale * interactionScale, anchor: .bottom)
        .offset(x: gazeOffset.width, y: gazeOffset.height)
        .rotationEffect(.degrees(rotation), anchor: .bottom)
        .shadow(color: .black.opacity(player.currentImage == nil ? 0 : 0.18), radius: 8, x: 0, y: 4)
    }

    private func celebrationProgress(at date: Date) -> CGFloat {
        let elapsed = date.timeIntervalSince(interaction.celebrationStartedAt)
        return max(CGFloat(0), min(CGFloat(1), CGFloat(elapsed / 1.25)))
    }

    private func groundShadow(sleeping: Bool, breath: CGFloat) -> some View {
        Ellipse()
            .fill(Color.black.opacity(player.currentImage == nil ? 0 : (interaction.dragging ? 0.08 : 0.14)))
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

    private func hearts(progress: CGFloat) -> some View {
        ZStack {
            floatingHeart(size: 30, x: -72, y: -112, lift: 78, drift: -24, delay: 0.00, progress: progress)
            floatingHeart(size: 24, x: -34, y: -138, lift: 88, drift: 18, delay: 0.04, progress: progress)
            floatingHeart(size: 34, x: 18, y: -126, lift: 96, drift: -10, delay: 0.08, progress: progress)
            floatingHeart(size: 22, x: 72, y: -118, lift: 76, drift: 28, delay: 0.12, progress: progress)
            floatingHeart(size: 18, x: 114, y: -72, lift: 68, drift: 24, delay: 0.18, progress: progress)
            floatingHeart(size: 20, x: -118, y: -62, lift: 64, drift: -20, delay: 0.22, progress: progress)
            floatingHeart(size: 16, x: 126, y: -12, lift: 52, drift: 16, delay: 0.30, progress: progress)
            floatingHeart(size: 18, x: -86, y: 8, lift: 58, drift: -18, delay: 0.34, progress: progress)
        }
    }

    private func floatingHeart(size: CGFloat, x: CGFloat, y: CGFloat, lift: CGFloat, drift: CGFloat, delay: CGFloat, progress: CGFloat) -> some View {
        let denominator = max(CGFloat(0.01), CGFloat(1) - delay)
        let local = max(CGFloat(0), min(CGFloat(1), (progress - delay) / denominator))
        let appear = min(CGFloat(1), local * 4)
        let fade = CGFloat(1) - local
        let opacity = Double(appear * fade)

        return Text("♥")
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(.pink.opacity(0.90))
            .scaleEffect(0.55 + local * 0.85)
            .rotationEffect(.degrees(Double(drift) * Double(local) * 0.22))
            .offset(x: x + drift * local, y: y - lift * local)
            .opacity(opacity)
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
}
