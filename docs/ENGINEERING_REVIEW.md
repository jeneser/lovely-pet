# Engineering Review

## Scope

Reviewed the current macOS desktop runtime, manifest loading, settings, packaging entry points, PNG frame playback, and interaction model.

## Principles applied

The implementation was checked against a small-diff engineering rule set: reuse native macOS and SwiftUI features, avoid new dependencies, keep interaction logic centralized, and prefer the smallest change that fixes the actual flow.

## Current implementation facts

- The visible character is backed by PNG frames loaded from `pet.json`.
- `PetInteractionModel` centralizes hover, tap, celebration, sleep, drag, gaze, message, and touched-zone state.
- Click-based affection increments and affection badge UI are not part of the current runtime.
- Double-click feedback is visual-only and uses a stronger heart burst instead of text feedback.
- Scale is persisted with `UserDefaults`.
- Window position is persisted in `PetWindowController`, where the real window movement occurs.
- Scale changes resize the transparent NSPanel so the PNG pet view and interaction viewport scale together.
- `PetManifest` supports packaged-app resource lookup and source-tree resource lookup.
- The status bar item uses a single icon and exposes Settings and Quit menu items.
- Settings includes scale controls and a Reset Stored Data action.
- Manifest checks require states to reference existing PNG frame files with dimensions matching the configured sprite canvas.

## Remaining risks

- The final visual behavior still needs local macOS GUI testing.
- Transparent-area hit testing is not implemented yet.
- Long-press feedback is intentionally simple and does not replace true drag-specific animation while moving the window.

## Local verification

Run `make validate`, `make build`, `make run`, and `make package` before releasing a distributable build.
