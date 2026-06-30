import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Pet") {
                Text("Lovely Pet")
                Text("Use pet.json to customize name, scale, states, and frame paths.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Next") {
                Text("Production settings should persist scale, position, click-through behavior, and launch-at-login preference.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: 360, height: 260)
    }
}
