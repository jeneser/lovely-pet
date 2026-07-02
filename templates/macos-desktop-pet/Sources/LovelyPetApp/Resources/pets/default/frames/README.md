# Frame Resources

The default pet ships with generated transparent PNG frame sequences instead of empty placeholders or a procedural SwiftUI cat renderer.

| State | Frames | fps | Loop | Purpose |
|---|---:|---:|---|---|
| `idle` | 10 | 12 | yes | breathing loop with blink/tail-sway in-betweens |
| `hover` | 8 | 16 | yes | attention/lean loop for cursor hover |
| `tap` | 8 | 18 | no | startled jump and recovery, then returns to `idle` |
| `sleep` | 8 | 8 | yes | slow loaf breathing loop |
| `walk_right` | 10 | 14 | yes | Dock walking loop moving right |
| `walk_left` | 10 | 14 | yes | mirrored Dock walking loop moving left |
| `idle_to_hover` | 2 | inherited | no | transition frames used by `idle.exitFrames` |
| `hover_to_idle` | 2 | inherited | no | transition frames used by `hover.exitFrames` |

All runtime frames are 300x300 PNG files with transparent backgrounds and bottom-aligned body anchors. Keep future replacements the same canvas size and start numbering at `0001.png` per state.
