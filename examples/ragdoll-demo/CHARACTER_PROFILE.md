# Ragdoll Demo Character Profile

This profile is derived from the supplied ragdoll cat photos and is used to keep the demo character consistent.

## Stable identity traits

- Long-haired ragdoll cat.
- Blue eyes with a soft, curious expression.
- Small pink nose.
- White muzzle and central white blaze on the face.
- Dark brown ears and eye mask.
- Cream-brown back patch.
- White chest, belly, and front legs.
- Large fluffy dark tail.

## Demo implementation

The current demo uses checked-in transparent PNG frame sequences rather than a SwiftUI procedural renderer. This keeps runtime behavior aligned with production asset-backed builds while still keeping the sample asset set lightweight.

## Production asset target

For a paid customer build, replace the sample PNGs with one of these asset modes:

1. `frameSequence`: transparent PNG frames for each state.
2. `skeletal2d`: layered parts or Live2D-style rig.

## Animation states

- `idle`: breathing, slight tail movement, calm posture.
- `hover`: attention, lifted ears, larger eyes, slight lean.
- `tap`: small bounce, sparkles, curious reaction.
- `sleep`: slow loaf breathing loop.
- `walk_right` / `walk_left`: Dock walking loops with direction-specific frames.
