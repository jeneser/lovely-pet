# Architecture

## Technical Direction

The runtime app is a native macOS desktop pet built with Swift, AppKit, and SwiftUI.

- AppKit owns the transparent floating window, event tracking, drag behavior, and menu bar integration.
- SwiftUI owns settings UI and lightweight configuration views.
- The first animation runtime is a frame-sequence state machine.
- A later version can replace the renderer with Live2D, Rive, or a custom skeletal rig without changing the order pipeline.

## Runtime Layers

```text
LovelyPetApp
  App bootstrap
  PetWindowController
  PetView
  FrameAnimationPlayer
  PetManifest
  PetSettings
  SettingsView
```

## Window Layer

The pet uses a borderless transparent `NSPanel` or `NSWindow`:

- always-on-top level by default;
- clear background;
- no title bar;
- optional shadow;
- draggable character area;
- mouse tracking for hover and click.

The product should avoid blocking desktop usage. The long-term target is hit-test passthrough outside the pet silhouette, but MVP can use a rectangular pet window for simplicity.

## Animation Layer

The MVP animation model is:

```json
{
  "states": {
    "idle": { "fps": 12, "loop": true, "frames": ["frames/idle/0001.png"] },
    "hover": { "fps": 16, "loop": true, "frames": ["frames/hover/0001.png"] },
    "tap": { "fps": 18, "loop": false, "frames": ["frames/tap/0001.png"] }
  }
}
```

Runtime states:

```text
idle -> hoverEnter -> hoverLoop -> tapReact -> idle
idle -> sleep -> wake -> idle
```

## Asset Layer

Every custom pet is a folder under:

```text
Resources/pets/<pet-id>/
  pet.json
  frames/
    idle/
    hover/
    tap/
    sleep/
```

The app template should not hard-code any pet identity. It reads `pet.json`, loads frames, and uses configuration values for scale, anchor, fps, and behavior flags.

## Pipeline Boundary

The template is intentionally dumb. It should not call AI APIs, payment APIs, or upload endpoints. Those belong to the business pipeline. The template receives a complete resource bundle and runs offline.

## Upgrade Path

1. MVP: PNG frame animation.
2. V1: alpha-hit testing, better transitions, signed builds.
3. V2: skeletal animation renderer.
4. V3: behavior engine with time, calendar, cursor, and user activity triggers.
