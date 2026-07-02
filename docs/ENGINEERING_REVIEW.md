# Engineering Review

## Scope

Reviewed the current macOS desktop pet runtime, manifest loading, image playback, settings, packaging entry points, window positioning, and interaction model.

## Principles applied

The implementation was checked against a small-diff engineering rule set: reuse native macOS and SwiftUI features, avoid new runtime dependencies, keep interaction logic centralized, and prefer the smallest change that fixes the actual animation flow.

## Fixes made

- Removed the SwiftUI procedural ragdoll cat renderer so runtime rendering is asset-backed only.
- Replaced Timer-driven frame playback with `CVDisplayLink` frame pacing and per-state fps throttling.
- Added `exitFrames` so state changes can play transition frames instead of hard-cutting directly to frame 0.
- Added startup frame preloading to remove first-play disk I/O stalls.
- Expanded the default image manifest with idle, hover, tap, sleep, walk-right, walk-left, and transition states.
- Added Dock-level window positioning and a menu action to toggle Dock walking.
- Kept user interaction state centralized in `PetInteractionModel` instead of scattering petting, affection, sleep, and gaze state through the view.
- Persisted affection, scale, and window position with `UserDefaults`, using native platform storage rather than adding a database or config layer.
- Added app bundle resource fallback in `PetManifest` so packaged app resources can be read from `Bundle.main`.

## Remaining risks

- The final visual behavior still needs local macOS GUI testing on real hardware.
- Transparent-area hit testing is not implemented yet.
- The generated sample frames are intentionally lightweight repository assets; paid builds should replace them with production AI/artist frames using the same manifest shape.
- Long-press feedback is intentionally simple and does not replace true drag-specific animation while moving the window.

## Local verification

```bash
make validate
make compat
make build
make run
make package
```
