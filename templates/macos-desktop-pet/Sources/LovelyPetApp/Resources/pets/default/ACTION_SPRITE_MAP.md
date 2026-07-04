# Imported action sprite sheets

The Google Drive bundle was normalized into runtime sprite sheets that match the existing `320x340` per-frame crop contract.

## Output contract

- Frame canvas: `320x340`
- Frames per action: `20`
- Sheet size per action: `6400x340`
- Layout: one horizontal row, addressed by `#0` through `#19`.
- The runtime player crops every sheet by fixed `320x340` slots.

## Actions

| State | Output sheet | FPS | Loop | Next state | Notes |
|---|---|---:|---:|---|---|
| `eat` | `frames/eat/eat-20f-sheet.png` | 8 | `false` | `idle` | Food bowl action, then idle. |
| `playPaperBall` | `frames/play-paper-ball/play-paper-ball-20f-sheet.png` | 10 | `false` | `idle` | Paper ball action, then idle. |
| `roll` | `frames/roll/roll-20f-sheet.png` | 8 | `false` | `idle` | Body interaction action, then idle. |
| `groom` | `frames/groom/groom-20f-sheet.png` | 8 | `false` | `idle` | Grooming action, then idle. |
| `run` | `frames/run/run-20f-sheet.png` | 12 | `false` | `idle` | Short locomotion action, then idle. |
| `walk` | `frames/walk/walk-20f-sheet.png` | 8 | `false` | `idle` | Short locomotion action, then idle. |
| `yawn` | `frames/yawn/yawn-20f-sheet.png` | 8 | `false` | `idle` or queued `sleep` | Yawn action, optionally followed by sleep. |
| `meow` | `frames/meow/meow-20f-sheet.png` | 8 | `false` | `idle` | Meow action, then idle. |

## Runtime trigger rules

See `ACTION_TRIGGER_RULES.md` for the interaction and ambient scheduling rules.

## Precision follow-up

The `yawn` sheet was regenerated with action-specific component isolation. The fixed sheet selects one detected yawn component per frame, rescales it into a centered `320x340` slot, and keeps the runtime sheet at `6400x340`.
