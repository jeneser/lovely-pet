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

            Section("Next") {
                Text("Production settings should also persist window position, launch-at-login, click-through behavior, and sound preference.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: 420, height: 320)
    }
}
