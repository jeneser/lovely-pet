# Customization Schema

`pet.json` is the contract between the customization pipeline and the macOS runtime template.

## Required Fields

```json
{
  "id": "default-cat",
  "name": "Lovely Cat",
  "renderer": { "type": "imageAssets" },
  "window": { "width": 320, "height": 340 },
  "behavior": {
    "hoverState": "hover",
    "tapState": "tap",
    "sleepState": "sleep"
  },
  "scale": 1.0,
  "anchor": "bottom-right",
  "defaultState": "idle",
  "states": {
    "idle": {
      "fps": 12,
      "loop": true,
      "frames": ["frames/idle/0001.png"],
      "exitFrames": ["frames/idle_to_hover/0001.png"]
    }
  }
}
```

## Runtime Interpretation

- `id`: stable pet resource identifier.
- `name`: display name in settings and menu.
- `renderer.type`: currently `imageAssets`.
- `window`: transparent panel size in points.
- `behavior`: state names used by interaction handlers.
- `scale`: default visual scale.
- `anchor`: default screen position strategy.
- `defaultState`: first state after launch.
- `states`: animation state definitions.

## State Fields

- `fps`: playback frame rate; `FrameAnimationPlayer` uses this to throttle `CVDisplayLink` ticks.
- `loop`: whether the state repeats.
- `frames`: resource-relative image paths for the state.
- `exitFrames`: optional resource-relative transition frames played before leaving the state.
- `nextState`: optional state after a non-looping animation completes.

## Built-in State Names

- `idle`: default calm loop.
- `hover`: cursor attention loop.
- `tap`: non-looping tap reaction.
- `sleep`: low-motion sleeping loop.
- `walk_right`: Dock walking loop moving right.
- `walk_left`: Dock walking loop moving left.

## Future Extension Fields

```json
{
  "hitTest": "alpha",
  "behaviors": {
    "followCursor": true,
    "sleepAfterSeconds": 300
  },
  "sounds": {
    "tap": "sounds/tap.m4a"
  }
}
```
