# Cat desktop pet asset pose map

Updated default pet animations use transparent PNG sprite sheets generated from the supplied ragdoll-cat references.

Frame groups:

- idle sheet: 15 cells. Neutral, blink, breathing, tail sway, and settle frames.
- hover sheet: 8 cells. Notice, ears perk, head tilt, lean, paw probe, paw hold, and recovery frames.
- tap sheet: 10 cells. Startle, crouch, hop, landing, recovery, and settle frames.
- sleep sheet: 7 cells. Lower, tuck paws, loaf, breathing, and twitch frames.

The manifest now sequences:

- idle: 17 runtime frames.
- hover: 9 runtime frames.
- tap: 13 runtime frames.
- sleep: 8 runtime frames.

The runtime crops addressed sprite cells from each sheet before SwiftUI displays them, so the pet keeps the existing image asset renderer while gaining smoother transitions.
