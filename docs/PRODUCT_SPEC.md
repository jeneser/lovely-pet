# Lovely Pet Product Spec

## 1. Product Goal

Lovely Pet is a reusable macOS desktop pet template. The repository should support many future pets rather than a single one-off app.

The project has three surfaces:

1. Pet resource preparation.
2. Manifest-driven app configuration.
3. Native macOS desktop pet runtime.

## 2. Target Users

- Pet owners who want a personalized desktop companion.
- People who want a lightweight digital companion on macOS.
- Creators and communities who want a mascot-like desktop character.

## 3. Core Experience

- Transparent floating desktop pet window.
- Menu bar controls.
- Hover, click, double-click, long-press, and zone-based touch feedback.
- Lightweight affection memory.
- Scale and position persistence.
- Resource-driven pet identity.

## 4. App States

```text
idle -> hover -> idle
idle -> tap -> idle
idle -> sleep -> wake -> idle
```

## 5. MVP Scope

1. Load a pet manifest.
2. Render a procedural ragdoll sample.
3. Support hover, tap, double tap, long press, and touch zones.
4. Persist scale, position, and affection.
5. Build a standalone macOS app bundle.
6. Upload a CI artifact for testing.

## 6. Out of Scope for Current Version

- Fully automated image generation.
- Live2D runtime integration.
- Cross-platform Windows/Linux versions.
- App Store distribution.

## 7. Quality Metrics

- App launch reliability.
- Interaction responsiveness.
- Visual consistency of the pet.
- Bundle build reproducibility.
- Clarity of the manifest and resource structure.
- Ease of adding a new pet resource pack.
