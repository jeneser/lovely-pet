# Engineering Review

## Scope

Reviewed the current macOS desktop runtime, manifest loading, settings, packaging entry points, PNG frame playback, and interaction model.

## Principles applied

The implementation was checked against a small-diff engineering rule set: reuse native macOS and SwiftUI features, avoid new dependencies, keep interaction logic centralized, and prefer the smallest change that fixes the actual flow.

## Fixes made

- Kept the visible character backed by PNG frames loaded from `pet.json`.
- Centralized interaction state in `PetInteractionModel` instead of scattering sleep, gaze, touch, and celebration state through the view.
- Removed click-based affection increments and the affection badge UI.
- Kept double-click feedback visual-only by replacing text feedback with a stronger heart burst.
- Persisted scale with `UserDefaults`, using native platform storage rather than adding a database or config layer.
- Persisted window position in `PetWindowController`, where the real window movement occurs.
- Resized the pet NSPanel when scale changes so the PNG pet view and transparent window scale together.
- Added app bundle resource fallback in `PetManifest` so packaged app resources can be read from `Bundle.main`.
- Added menu actions for showing and resetting the window position.
- Added manifest checks so states must reference existing PNG frame files with dimensions matching the configured sprite canvas.

## Remaining risks

- The final visual behavior still needs local macOS GUI testing.
- Transparent-area hit testing is not implemented yet.
- Long-press feedback is intentionally simple and does not replace true drag-specific animation while moving the window.

## Local verification

Run `make validate`, `make build`, `make run`, and `make package` before releasing a distributable build.
