# Lovely Pet

Lovely Pet is a reusable macOS desktop pet template. It combines pet assets, interaction configuration, and a native macOS runtime into a standalone desktop companion app.

[中文说明](README.zh-CN.md)

The current version works out of the box with an asset-backed ragdoll cat sample. The runtime reads transparent PNG frame sequences from `pet.json`, preloads them, and plays them with a display-synchronized frame player. The SwiftUI procedural ragdoll renderer has been removed so production behavior always matches the checked-in image assets.

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

GitHub Actions produces downloadable build artifacts named by runner OS, for example:

```text
Lovely-Pet-macOS-macos-14
```

## Included

- Native Swift + AppKit + SwiftUI macOS desktop pet runtime
- Transparent Dock-level pet window, menu bar entry, hover, click, double-click, long-press, and Dock walk controls
- Asset-backed PNG frame animation for idle, hover, tap, sleep, walk-right, and walk-left states
- CVDisplayLink frame pacing, transition frames, and startup frame preloading
- Cursor tracking, petting zones, affection memory, sleepy state, persistent scale, and persistent window position
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

The current focus is product feel: smooth PNG frame playback, transition-buffered state changes, Dock walking, natural hover response, cursor-aware gaze, petting-zone feedback, simple affection memory, sleepy rhythm, predictable local state, Xcode-friendly debugging, and stable macOS packaging.
