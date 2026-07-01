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
                Slider(value: $settings.scale, in: 0.6...1.8) {
                    Text("Scale")
                }
                HStack {
                    Text("Scale")
                    Spacer()
                    Text("\(settings.scale, specifier: "%.2f")x")
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
                Text("Clears affection, saved scale, and saved window position from UserDefaults.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: 420, height: 340)
    }
}
