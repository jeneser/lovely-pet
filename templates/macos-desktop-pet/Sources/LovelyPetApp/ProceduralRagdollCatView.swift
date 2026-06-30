import SwiftUI

struct ProceduralRagdollCatView: View {
    let hovering: Bool

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: hovering ? 180 : 160, height: hovering ? 180 : 160)
    }
}
