# macOS Desktop Pet Template

This is the reusable native macOS runtime for Lovely Pet.

## Run

```bash
swift run LovelyPetApp
```

## Package

```bash
sh scripts/package-app.sh
open "dist/Lovely Pet Demo.app"
```

## Current renderer

The default demo uses `ProceduralRagdollCatView`, a SwiftUI renderer based on the supplied ragdoll cat photos. It does not require PNG assets, so the template can run immediately after cloning.

## Production extension points

- Replace the procedural view with a single transparent sprite renderer.
- Add frame sequence playback for generated PNG animation states.
- Add layered or skeletal rendering for premium paid builds.
- Keep customer-specific data in `Resources/pets/<pet-id>/pet.json`.
