# Lovely Pet Product Spec

## Product Goal

Lovely Pet is a reusable macOS desktop companion template. The repository should support many future asset packs rather than a single one-off app.

The project has three surfaces: resource preparation, manifest-driven app configuration, and a native macOS runtime.

## Core Experience

- Transparent floating desktop window.
- Menu bar controls.
- Hover, click, double-click, long-press, and zone-based touch feedback.
- Lightweight affection memory.
- Scale and position persistence.
- Resource-driven identity.

## App States

The runtime switches between idle, hover, tap, and sleep states according to `pet.json`.

## MVP Scope

1. Load a manifest.
2. Render a PNG frame-sequence sample through the `imageAssets` renderer.
3. Support hover, tap, double tap, long press, and touch zones.
4. Persist scale, position, and affection.
5. Build a standalone macOS app bundle.
6. Upload a CI artifact for testing.

## Out of Scope for Current Version

- Fully automated image generation.
- Live2D runtime integration.
- Cross-platform Windows/Linux versions.
- App Store distribution.

## Quality Metrics

- App launch reliability.
- Interaction responsiveness.
- Visual consistency of the PNG frames.
- Bundle build reproducibility.
- Clarity of the manifest and resource structure.
- Ease of adding a new resource pack.
