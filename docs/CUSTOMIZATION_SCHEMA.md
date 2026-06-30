# Customization Schema

`pet.json` is the contract between the customization pipeline and the macOS runtime template.

## Required Fields

```json
{
  "id": "default-cat",
  "name": "Lovely Cat",
  "scale": 1.0,
  "anchor": "bottom-right",
  "defaultState": "idle",
  "states": {
    "idle": {
      "fps": 12,
      "loop": true,
      "frames": ["frames/idle/0001.png"]
    }
  }
}
```

## Runtime Interpretation

- `id`: stable pet resource identifier.
- `name`: display name in settings and menu.
- `scale`: default visual scale.
- `anchor`: default screen position strategy.
- `defaultState`: first state after launch.
- `states`: animation state definitions.

## State Fields

- `fps`: playback frame rate.
- `loop`: whether the state repeats.
- `frames`: resource-relative image paths.
- `nextState`: optional state after a non-looping animation completes.

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
