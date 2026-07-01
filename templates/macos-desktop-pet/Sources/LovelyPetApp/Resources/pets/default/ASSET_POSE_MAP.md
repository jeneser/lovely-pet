# Cat desktop pet asset pose map

This asset set replaces the default placeholder frames with high-resolution transparent PNG images. The runtime keeps images in PNG format and uses SwiftUI `scaledToFit()` rendering to avoid stretching.

## Pose recognition

| Runtime file | Recognized pose | Interaction role |
|---|---|---|
| `frames/idle/0001-stand.png` | 3/4 standing, eyes open, neutral body | Main idle anchor frame |
| `frames/idle/0002-blink.png` | Same standing stance, slow blink | Idle blink key frame |
| `frames/idle/0003-tail-sway.png` | Same standing stance with subtle head/tail variation | Idle tail-sway/breathing key frame |
| `frames/hover/0001-notice.png` | Attention pose, alert eyes, slight forward curiosity | Hover enter / hover recovery |
| `frames/hover/0002-paw-probe.png` | One front paw lifted for a soft testing gesture | Hover loop interaction |
| `frames/tap/0001-startle.png` | Small startled hop/flinch, open mouth | Tap reaction opener |
| `frames/sleep/0001-loaf.png` | Loaf/resting pose, eyes closed, tail tucked | Sleep state |
| `refs/gold-standard.png` | Master 3/4 identity reference | Future pose consistency reference |
| `layered/layered-parts-sheet.png` | Separated rigging parts | Live2D/skeletal-animation reference |

## Interaction sequencing

```text
idle:
  stand -> blink -> stand -> tail-sway -> stand

hover:
  notice -> paw-probe -> notice

tap:
  startle -> paw-probe -> notice -> stand -> idle

sleep:
  loaf
```

## Quality notes

- Images are transparent PNG assets.
- No JPEG conversion is used.
- No lossy image compression or downsampling is applied to the runtime frames.
- UI display must keep the existing aspect-ratio-preserving rendering path.
