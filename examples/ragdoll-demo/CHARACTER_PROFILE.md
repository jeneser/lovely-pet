# Ragdoll Demo Character Profile

This profile is derived from the supplied ragdoll cat photos and is used to keep the PNG frame assets consistent.

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

The current demo uses transparent PNG frame assets committed under `templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames`. The runtime reads the frame sequence from `pet.json` and displays the current frame with `PetImageAssetView`.

## Production asset target

For a customer build, replace or extend the PNG frame set with one of these asset modes:

1. `imageAssets`: transparent PNG frames for each state.
2. `skeletal2d`: layered parts or Live2D-style rig.

## Animation states

- `idle`: stand, blink, and tail-sway frames.
- `hover`: attention and paw-probe frames.
- `tap`: startled reaction sequence.
- `sleep`: loaf/rest frame.
