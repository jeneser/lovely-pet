# Engineering Review

## Scope

Reviewed the current macOS desktop pet runtime, manifest loading, settings, packaging entry points, and interaction model.

## Principles applied

The implementation was checked against a small-diff engineering rule set: reuse native macOS and SwiftUI features, avoid new dependencies, keep interaction logic centralized, and prefer the smallest change that fixes the actual flow.

## Fixes made

- Kept the procedural renderer image-free so the project remains runnable immediately after clone.
- Centralized user interaction state in `PetInteractionModel` instead of scattering petting, affection, sleep, and gaze state through the view.
- Persisted affection and scale with `UserDefaults`, using native platform storage rather than adding a database or config layer.
- Persisted window position in `PetWindowController`, where the real window movement occurs.
- Added app bundle resource fallback in `PetManifest` so packaged app resources can be read from `Bundle.main`.
- Increased the pet window size to avoid clipping the richer procedural view.
- Added menu actions for showing and resetting the pet position.

## Remaining risks

- The final visual behavior still needs local macOS GUI testing.
- Transparent-area hit testing is not implemented yet.
- The current procedural renderer is good for demo and product feel, but paid builds should move to asset-backed or skeletal rendering.
- Long-press feedback is intentionally simple and does not replace true drag-specific animation while moving the window.

## Local verification

```bash
make validate
make build
make run
make package
```
