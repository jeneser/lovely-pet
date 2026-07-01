# Lovely Pet

Lovely Pet is a reusable macOS desktop pet template. It combines pet assets, interaction configuration, and a native macOS runtime into a standalone desktop companion app.

[中文说明](README.zh-CN.md)

The current version works out of the box. After cloning the repository, you can run a ragdoll cat sample immediately. The sample does not require external image assets; it uses SwiftUI to draw a procedural character based on stable ragdoll-cat visual traits, with lightweight interactions such as hover, click, double-click, long-press, petting zones, affection memory, scale settings, and a sleepy rhythm.

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

GitHub Actions produces a downloadable build artifact:

```text
Lovely-Pet-macOS
```

## Included

- Native Swift + AppKit + SwiftUI macOS desktop pet runtime
- Transparent floating window, menu bar entry, hover, click, double-click, and long-press interactions
- Procedural ragdoll cat sample that runs without image assets
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

The current focus is product feel: natural hover response, cursor-aware gaze, petting-zone feedback, simple affection memory, sleepy rhythm, predictable local state, Xcode-friendly debugging, and stable macOS packaging.
