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

The current demo uses a SwiftUI procedural renderer instead of committing the raw photos or generated binary assets. This keeps the repository small, private-data safe, and immediately runnable.

## Production asset target

For a paid customer build, replace the procedural renderer with one of these asset modes:

1. `singleSprite`: one transparent PNG with transform animation.
2. `frameSequence`: transparent PNG frames for each state.
3. `skeletal2d`: layered parts or Live2D-style rig.

## Animation states

- `idle`: breathing, slight tail movement, calm posture.
- `hover`: attention, lifted ears, larger eyes, slight lean.
- `tap`: small bounce, sparkles, curious reaction.
- `sleep`: reserved for later time-based behavior.
