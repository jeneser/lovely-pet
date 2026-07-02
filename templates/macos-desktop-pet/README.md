# macOS Desktop Pet Template

This is the reusable native macOS runtime for Lovely Pet.

## Run

```bash
swift run LovelyPetApp
```

## Open in Xcode

From the repository root:

```bash
make xcode
```

Or open this directory directly in Xcode. Select the `LovelyPetApp` scheme and run on `My Mac`.

## Package

```bash
sh scripts/package-app.sh
open "dist/Lovely Pet.app"
```

## Current renderer

The default sample uses `PetImageAssetView` and `FrameAnimationPlayer` to play transparent PNG frame sequences declared by `Resources/pets/default/pet.json`. Runtime drawing no longer uses `ProceduralRagdollCatView`.

## Extension points

- Replace the default PNG frame pack with a customer-specific transparent frame sequence.
- Add more transition states through `exitFrames` in `pet.json`.
- Add layered or skeletal rendering for advanced builds.
- Keep pet-specific data in `Resources/pets/<pet-id>/pet.json`.
