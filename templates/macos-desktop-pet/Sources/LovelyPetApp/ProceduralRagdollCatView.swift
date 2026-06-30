import SwiftUI

struct ProceduralRagdollCatView: View {
    let hovering: Bool

    private let furWhite = Color(red: 1.00, green: 0.98, blue: 0.92)
    private let cream = Color(red: 0.72, green: 0.55, blue: 0.38)
    private let seal = Color(red: 0.27, green: 0.19, blue: 0.15)
    private let eyeBlue = Color(red: 0.42, green: 0.72, blue: 0.95)
    private let nosePink = Color(red: 0.95, green: 0.55, blue: 0.62)

    var body: some View {
        ZStack {
            tail
            bodyShape
            backPatch
            paws
            head
            ears
            faceMask
            eyes
            nose
            whiskers
        }
        .frame(width: 260, height: 280)
        .scaleEffect(hovering ? 1.06 : 1.0)
        .offset(y: hovering ? -8 : 0)
        .rotationEffect(.degrees(hovering ? 3 : 0))
        .animation(.spring(response: 0.28, dampingFraction: 0.72), value: hovering)
        .accessibilityLabel("Lovely Ragdoll desktop pet")
    }

    private var tail: some View {
        Capsule()
            .fill(seal)
            .frame(width: 112, height: 40)
            .rotationEffect(.degrees(-24))
            .offset(x: -74, y: 70)
    }

    private var bodyShape: some View {
        Ellipse()
            .fill(furWhite)
            .frame(width: 160, height: 172)
            .offset(x: -4, y: 54)
            .shadow(radius: 5, x: 0, y: 3)
    }

    private var backPatch: some View {
        Ellipse()
            .fill(cream.opacity(0.86))
            .frame(width: 108, height: 78)
            .rotationEffect(.degrees(-18))
            .offset(x: -42, y: 32)
    }

    private var paws: some View {
        HStack(spacing: 18) {
            Capsule().fill(furWhite).frame(width: 30, height: 80)
            Capsule().fill(furWhite).frame(width: 30, height: 80)
        }
        .offset(x: 32, y: 92)
    }

    private var head: some View {
        Circle()
            .fill(furWhite)
            .frame(width: 120, height: 120)
            .offset(x: 38, y: -54)
            .shadow(radius: 4, x: 0, y: 2)
    }

    private var ears: some View {
        ZStack {
            EarShape().fill(seal).frame(width: 44, height: 54).rotationEffect(.degrees(-20)).offset(x: -6, y: -116)
            EarShape().fill(seal).frame(width: 44, height: 54).rotationEffect(.degrees(20)).offset(x: 86, y: -116)
        }
    }

    private var faceMask: some View {
        ZStack {
            Ellipse().fill(seal.opacity(0.92)).frame(width: 50, height: 68).rotationEffect(.degrees(24)).offset(x: 8, y: -64)
            Ellipse().fill(seal.opacity(0.82)).frame(width: 54, height: 72).rotationEffect(.degrees(-22)).offset(x: 78, y: -64)
            BlazeShape().fill(furWhite).frame(width: 62, height: 86).offset(x: 42, y: -70)
        }
    }

    private var eyes: some View {
        HStack(spacing: 26) {
            eye
            eye
        }
        .offset(x: 43, y: -56)
    }

    private var eye: some View {
        Circle()
            .fill(eyeBlue)
            .frame(width: 24, height: 24)
            .overlay(Circle().fill(Color.black).frame(width: 10, height: 10))
            .overlay(Circle().fill(Color.white).frame(width: 5, height: 5).offset(x: -5, y: -5))
    }

    private var nose: some View {
        NoseShape()
            .fill(nosePink)
            .frame(width: 18, height: 14)
            .offset(x: 43, y: -28)
    }

    private var whiskers: some View {
        ZStack {
            Capsule().fill(Color.white.opacity(0.85)).frame(width: 56, height: 2).rotationEffect(.degrees(-10)).offset(x: -6, y: -24)
            Capsule().fill(Color.white.opacity(0.85)).frame(width: 56, height: 2).rotationEffect(.degrees(8)).offset(x: -6, y: -15)
            Capsule().fill(Color.white.opacity(0.85)).frame(width: 56, height: 2).rotationEffect(.degrees(10)).offset(x: 92, y: -24)
            Capsule().fill(Color.white.opacity(0.85)).frame(width: 56, height: 2).rotationEffect(.degrees(-8)).offset(x: 92, y: -15)
        }
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
