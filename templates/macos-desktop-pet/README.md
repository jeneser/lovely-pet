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

The default sample uses `ProceduralRagdollCatView`, a SwiftUI renderer based on ragdoll cat visual traits. It does not require PNG assets, so the template can run immediately after cloning.

## Extension points

- Replace the procedural view with a single transparent sprite renderer.
- Add frame sequence playback for generated PNG animation states.
- Add layered or skeletal rendering for advanced builds.
- Keep pet-specific data in `Resources/pets/<pet-id>/pet.json`.
