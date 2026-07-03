import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: PetSettings

    var body: some View {
        Form {
            Section("Pet") {
                Text(settings.manifest.name)
                Text("Use pet.json to customize identity, renderer, states, and resources.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Display") {
                VStack(alignment: .leading, spacing: 8) {
                    Slider(value: $settings.scale, in: 0.6...1.8, step: 0.05) {
                        Text("Scale")
                    }

                    HStack {
                        Text("Pet Scale")
                        Spacer()
                        Text("\(settings.scale, specifier: "%.2f")x")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }

                    Text("Resizes the PNG pet canvas and transparent window together so enlarged frames are not clipped.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("Canvas: \(Int(settings.scaledWindowSize.width)) × \(Int(settings.scaledWindowSize.height)) px")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button("Reset Scale") {
                    settings.resetScale()
                }
            }

            Section("Local Data") {
                Button("Reset Stored Data") {
                    settings.resetLocalData()
                }
                Text("Clears saved scale, saved window position, and any legacy affection counter from UserDefaults.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: 460, height: 380)
    }
}
