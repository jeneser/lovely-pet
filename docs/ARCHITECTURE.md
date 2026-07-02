# Architecture

## Technical Direction

The runtime app is a native macOS desktop pet built with Swift, AppKit, and SwiftUI.

- AppKit owns the transparent Dock-level window, event tracking, drag behavior, Dock walking position, and menu bar integration.
- SwiftUI owns the pet view composition, overlays, settings UI, and lightweight configuration views.
- The animation runtime is a manifest-driven PNG frame-sequence state machine.
- Later versions can replace the renderer with Live2D, Rive, or a custom skeletal rig without changing the order pipeline.

## Runtime Layers

```text
LovelyPetApp
  App bootstrap
  PetWindowController
  PetView
  PetImageAssetView
  FrameAnimationPlayer
  PetManifest
  PetSettings
  SettingsView
```

The previous SwiftUI `ProceduralRagdollCatView` path has been removed. All visible pet animation now comes from image assets declared by `pet.json`.

## Window Layer

The pet uses a borderless transparent `NSPanel`:

- level is `dockWindowLevel + 1` so the pet can walk visually above the Dock;
- clear background;
- no title bar;
- optional shadow;
- draggable character area;
- mouse tracking for hover and click.

Dock walking uses `NSScreen.frame` and `NSScreen.visibleFrame` to infer the bottom Dock area when present, then moves the window horizontally along the Dock top edge.

## Animation Layer

The animation model is:

```json
{
  "states": {
    "idle": { "fps": 12, "loop": true, "frames": ["frames/idle/0001.png"], "exitFrames": ["frames/idle_to_hover/0001.png"] },
    "hover": { "fps": 16, "loop": true, "frames": ["frames/hover/0001.png"] },
    "tap": { "fps": 18, "loop": false, "frames": ["frames/tap/0001.png"], "nextState": "idle" },
    "walk_right": { "fps": 14, "loop": true, "frames": ["frames/walk_right/0001.png"] },
    "walk_left": { "fps": 14, "loop": true, "frames": ["frames/walk_left/0001.png"] }
  }
}
```

Runtime states:

```text
idle -> hover -> idle
idle -> tap -> idle
idle -> sleep -> wake -> idle
idle -> walk_right <-> walk_left -> idle
```

`FrameAnimationPlayer` uses `CVDisplayLink` for display-synchronized callbacks and throttles frame advancement according to the state `fps`. Startup calls `preloadAllFrames()` so the first interactive playback does not wait on disk I/O.

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
    walk_right/
    walk_left/
    idle_to_hover/
    hover_to_idle/
```

The app template should not hard-code any pet identity. It reads `pet.json`, loads frames, and uses configuration values for scale, anchor, window size, fps, behavior states, and transition frames.

## Pipeline Boundary

The template is intentionally dumb. It should not call AI APIs, payment APIs, or upload endpoints. Those belong to the business pipeline. The template receives a complete resource bundle and runs offline.

## Upgrade Path

1. MVP: PNG frame animation with `CVDisplayLink` playback.
2. V1: alpha-hit testing, richer transition maps, signed builds.
3. V2: skeletal animation renderer.
4. V3: behavior engine with time, calendar, cursor, and user activity triggers.
