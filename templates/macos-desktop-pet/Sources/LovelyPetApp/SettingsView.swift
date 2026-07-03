import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: PetSettings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header

                SettingsCard("Pet", subtitle: "PNG frame asset profile") {
                    metricRow(label: "Name", value: settings.manifest.name)
                    metricRow(label: "Default state", value: settings.manifest.defaultState)
                    metricRow(label: "Anchor", value: settings.manifest.anchor)
                }

                SettingsCard("Display", subtitle: "Fine tune pet scale and interaction room") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Scale")
                                .font(.headline)
                            Spacer()
                            Text("\(settings.scale, specifier: "%.2f")x")
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }

                        Slider(
                            value: $settings.scale,
                            in: PetSettings.minimumScale...PetSettings.maximumScale,
                            step: 0.05
                        ) {
                            Text("Scale")
                        }

                        HStack {
                            Text("Small · \(PetSettings.minimumScale, specifier: "%.2f")x")
                            Spacer()
                            Text("Large · \(PetSettings.maximumScale, specifier: "%.2f")x")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        Divider()

                        metricRow(label: "PNG canvas", value: "\(Int(settings.baseWindowSize.width)) × \(Int(settings.baseWindowSize.height)) pt")
                        metricRow(label: "Interaction viewport", value: "\(Int(settings.viewportWindowSize.width)) × \(Int(settings.viewportWindowSize.height)) pt")
                        metricRow(label: "Current window", value: "\(Int(settings.scaledWindowSize.width)) × \(Int(settings.scaledWindowSize.height)) pt")
                        Text("The PNG canvas stays aligned with the sprite sheet. The transparent interaction viewport adds extra margin so hover and double-click heart feedback can expand without clipping.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack {
                            Button("Reset to Default") {
                                settings.resetScale()
                            }
                            Spacer()
                            Text("Default: \(settings.defaultScale, specifier: "%.2f")x")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                SettingsCard("Local Data", subtitle: "Stored in UserDefaults") {
                    Text("Resetting clears saved scale and saved window position, and also removes any legacy affection counter written by older builds. The pet returns to the default 0.60x size on the next launch.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Button("Reset Stored Data") {
                        settings.resetLocalData()
                    }
                }
            }
            .padding(22)
        }
        .frame(width: 500, height: 520)
    }

    private var header: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.primary.opacity(0.08))
                    .frame(width: 48, height: 48)
                Text("🐾")
                    .font(.system(size: 24))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Lovely Pet Settings")
                    .font(.title2.weight(.semibold))
                Text("Scale, viewport, and local runtime state")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func metricRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer(minLength: 16)
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

private struct SettingsCard<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content

    init(_ title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.primary.opacity(0.035))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}
