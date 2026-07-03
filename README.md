# Lovely Pet

Lovely Pet is a reusable macOS desktop pet template. It combines pet assets, interaction configuration, and a native macOS runtime into a standalone desktop companion app.

[中文说明](README.zh-CN.md)

The current version works out of the box. After cloning the repository, you can run a ragdoll cat sample immediately. The sample uses manifest-driven transparent PNG image frames from `Resources/pets/default/frames`, with lightweight interactions such as hover, click, double-click heart bursts, long-press/drag feedback, touch zones, scale settings, and a sleepy rhythm.

## Quick start

```bash
make validate
make run
```

Open in Xcode:

```bash
make xcode
```

Package the app:

```bash
make package
open "templates/macos-desktop-pet/dist/Lovely Pet.app"
```

GitHub Actions produces downloadable build artifacts for each macOS runner in the CI matrix.

## Included

- Native Swift + AppKit + SwiftUI macOS desktop pet runtime
- Transparent floating window with a menu bar item for Settings and Quit
- Hover, click, double-click, long-press, and zone-based interactions
- PNG frame-sequence ragdoll cat sample loaded through `pet.json`
- Cursor tracking, touch-zone visual feedback, enhanced heart bursts, sleepy state, persistent scale, and persistent window position
- Manifest-based configuration and validation script
- Xcode debugging support through the Swift Package
- App packaging workflow and GitHub Actions artifact upload
- Documentation for setup, Xcode debugging, interaction design, runtime safety, asset preparation, testing, and engineering review

## Repository layout

```text
docs/                         Documentation
templates/macos-desktop-pet/   macOS desktop pet runtime template
pipeline/                      Schemas, validation scripts, and asset prompts
examples/ragdoll-demo/         Ragdoll character profile and notes
```

## Key docs

- `docs/GETTING_STARTED.md`
- `docs/XCODE_DEBUGGING.md`
- `docs/INTERACTION_DESIGN.md`
- `docs/RUNTIME_SAFETY.md`
- `docs/ENGINEERING_REVIEW.md`
- `docs/ASSET_PIPELINE.md`
- `docs/BUILD_PIPELINE.md`
- `docs/TESTING.md`
- `docs/ROADMAP.md`
- `examples/ragdoll-demo/CHARACTER_PROFILE.md`

## Current focus

The current focus is product feel on top of PNG frame playback: natural hover response, cursor-aware movement, touch-zone visual feedback, stronger non-text double-click visual feedback, sleepy rhythm, predictable local state, Xcode-friendly debugging, and stable macOS packaging.
