import SwiftUI
import Foundation

struct ProceduralRagdollCatView: View {
    @ObservedObject var interaction: PetInteractionModel

    private let furWhite = Color(red: 1.00, green: 0.98, blue: 0.92)
    private let cream = Color(red: 0.72, green: 0.55, blue: 0.38)
    private let seal = Color(red: 0.27, green: 0.19, blue: 0.15)
    private let eyeBlue = Color(red: 0.42, green: 0.72, blue: 0.95)
    private let nosePink = Color(red: 0.95, green: 0.55, blue: 0.62)

    var body: some View {
        TimelineView(.animation) { timeline in
            let phase = timeline.date.timeIntervalSinceReferenceDate
            let breath = CGFloat(sin(phase * 2.1))
            let baseTail = CGFloat(sin(phase * 3.2)) * (interaction.hovering ? 8 : 3)
            let tailWag = baseTail + (interaction.dragging ? 10 : 0)
            let blink = interaction.asleep ? true : Int(phase * 2.0) % 9 == 0

            ZStack {
                groundShadow(breath: breath)
                tail(wag: tailWag)
                bodyShape(breath: breath)
                backPatch
                paws(breath: breath)
                head(breath: breath)
                ears
                faceMask
                eyes(blink: blink)
                nose
                whiskers
                if interaction.tapping { tapSparkles }
                if interaction.dragging { dragFeedback }
                if interaction.celebrating { hearts }
                if let zone = interaction.touchedZone { touchFeedback(zone) }
                if let message = interaction.message { messageBubble(message) }
                affectionBadge
            }
            .frame(width: 280, height: 310)
            .scaleEffect(interaction.dragging ? 0.96 : (interaction.tapping ? 1.10 : (interaction.hovering ? 1.06 : 1.0)))
            .offset(y: interaction.dragging ? -12 : (interaction.tapping ? -20 : (interaction.hovering ? -8 : -breath * 2)))
            .rotationEffect(.degrees(interaction.dragging ? Double(interaction.gazeX * 8) : (interaction.tapping ? -6 : (interaction.hovering ? 3 : 0))))
            .animation(.spring(response: 0.28, dampingFraction: 0.72), value: interaction.hovering)
            .animation(.spring(response: 0.22, dampingFraction: 0.48), value: interaction.tapping)
            .animation(.spring(response: 0.36, dampingFraction: 0.55), value: interaction.celebrating)
            .animation(.spring(response: 0.18, dampingFraction: 0.45), value: interaction.dragging)
            .accessibilityLabel("Lovely Ragdoll desktop pet")
        }
    }

    private func groundShadow(breath: CGFloat) -> some View {
        Ellipse()
            .fill(Color.black.opacity(interaction.dragging ? 0.08 : 0.14))
            .frame(width: 158 + breath * 2, height: 24)
            .offset(x: -4, y: 150)
            .blur(radius: 4)
    }

    private func tail(wag: CGFloat) -> some View {
        Capsule()
            .fill(seal)
            .frame(width: 120, height: 42)
            .rotationEffect(.degrees(-24 + Double(wag)))
            .offset(x: -82, y: 72)
            .shadow(radius: 3, x: 0, y: 2)
    }

    private func bodyShape(breath: CGFloat) -> some View {
        Ellipse()
            .fill(furWhite)
            .frame(width: 166 + breath * 2, height: 176 + breath * 3)
            .offset(x: -6, y: 58)
            .shadow(radius: 5, x: 0, y: 3)
    }

    private var backPatch: some View {
        Ellipse()
            .fill(cream.opacity(0.86))
            .frame(width: 112, height: 82)
            .rotationEffect(.degrees(-18))
            .offset(x: -46, y: 34)
    }

    private func paws(breath: CGFloat) -> some View {
        HStack(spacing: 18) {
            Capsule().fill(furWhite).frame(width: 31, height: interaction.dragging ? 66 : (interaction.tapping ? 70 : 82))
            Capsule().fill(furWhite).frame(width: 31, height: interaction.dragging ? 66 : (interaction.hovering ? 74 : 82))
        }
        .offset(x: 34, y: 94 + breath)
    }

    private func head(breath: CGFloat) -> some View {
        Circle()
            .fill(furWhite)
            .frame(width: 124, height: 124)
            .offset(x: 40 + CGFloat(interaction.gazeX) * 3, y: -56 + breath)
            .shadow(radius: 4, x: 0, y: 2)
    }

    private var ears: some View {
        ZStack {
            EarShape().fill(seal).frame(width: 45, height: interaction.hovering ? 62 : 55).rotationEffect(.degrees(interaction.dragging ? -30 : -20)).offset(x: -8, y: -120)
            EarShape().fill(seal).frame(width: 45, height: interaction.hovering ? 62 : 55).rotationEffect(.degrees(interaction.dragging ? 30 : 20)).offset(x: 88, y: -120)
        }
    }

    private var faceMask: some View {
        ZStack {
            Ellipse().fill(seal.opacity(0.92)).frame(width: 52, height: 70).rotationEffect(.degrees(24)).offset(x: 8, y: -66)
            Ellipse().fill(seal.opacity(0.82)).frame(width: 56, height: 74).rotationEffect(.degrees(-22)).offset(x: 80, y: -66)
            BlazeShape().fill(furWhite).frame(width: 64, height: 88).offset(x: 44, y: -72)
        }
    }

    private func eyes(blink: Bool) -> some View {
        HStack(spacing: 26) {
            eye(blink: blink)
            eye(blink: blink)
        }
        .offset(x: 45, y: -58)
    }

    private func eye(blink: Bool) -> some View {
        Group {
            if blink {
                Capsule().fill(seal).frame(width: 24, height: 4)
            } else {
                Circle()
                    .fill(eyeBlue)
                    .frame(width: interaction.hovering ? 27 : 24, height: interaction.hovering ? 27 : 24)
                    .overlay(Circle().fill(Color.black).frame(width: 10, height: 10).offset(x: CGFloat(interaction.gazeX * 4), y: CGFloat(interaction.gazeY * 3)))
                    .overlay(Circle().fill(Color.white).frame(width: 5, height: 5).offset(x: -5, y: -5))
            }
        }
    }

    private var nose: some View {
        NoseShape()
            .fill(nosePink)
            .frame(width: 18, height: 14)
            .offset(x: 45, y: -30)
    }

    private var whiskers: some View {
        ZStack {
            Capsule().fill(Color.white.opacity(0.85)).frame(width: 56, height: 2).rotationEffect(.degrees(-10)).offset(x: -6, y: -26)
            Capsule().fill(Color.white.opacity(0.85)).frame(width: 56, height: 2).rotationEffect(.degrees(8)).offset(x: -6, y: -17)
            Capsule().fill(Color.white.opacity(0.85)).frame(width: 56, height: 2).rotationEffect(.degrees(10)).offset(x: 96, y: -26)
            Capsule().fill(Color.white.opacity(0.85)).frame(width: 56, height: 2).rotationEffect(.degrees(-8)).offset(x: 96, y: -17)
        }
    }

    private var tapSparkles: some View {
        ZStack {
            Circle().fill(Color.yellow.opacity(0.85)).frame(width: 8, height: 8).offset(x: -38, y: -126)
            Circle().fill(Color.yellow.opacity(0.65)).frame(width: 6, height: 6).offset(x: 124, y: -106)
            Circle().fill(Color.yellow.opacity(0.75)).frame(width: 5, height: 5).offset(x: 108, y: -30)
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

struct EarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct BlazeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control1: CGPoint(x: rect.maxX * 0.74, y: rect.height * 0.28), control2: CGPoint(x: rect.maxX * 0.92, y: rect.height * 0.70))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), control1: CGPoint(x: rect.width * 0.10, y: rect.height * 0.70), control2: CGPoint(x: rect.width * 0.28, y: rect.height * 0.28))
        path.closeSubpath()
        return path
    }
}

struct NoseShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
