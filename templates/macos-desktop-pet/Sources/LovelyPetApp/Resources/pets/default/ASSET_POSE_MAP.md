# Cat desktop pet asset pose map

This asset set uses transparent PNG sprite sheets generated from the supplied ragdoll-cat references. Every subframe is normalized to the app window canvas (`320x340`), and `pet.json` addresses each runtime frame with unique sprite-sheet filenames plus `#index` references. The filenames are unique because SwiftPM rejects duplicate processed resource names across resource folders.

## Pose groups

| Runtime group | Sheet frames | Role |
|---|---:|---|
| `frames/idle/idle-sheet.png` | `#0`-`#14` | Neutral breathing, blink, reopen, tail sway, and return-to-stand in-betweens |
| `frames/hover/hover-sheet.png` | `#0`-`#7` | Notice, ears-perk, head tilt, forward lean, paw probe, paw hold, and recovery |
| `frames/tap/tap-sheet.png` | `#0`-`#9` | Startle, hop/landing, paw-settle, attention recovery, and return-to-idle transition |
| `frames/sleep/sleep-sheet.png` | `#0`-`#6` | Lowering, paw tuck, loaf, breathing, and sleep twitch loop |

## Key-frame supplementation

| Original transition | Added runtime in-betweens |
|---|---|
| `idle` stand -> blink | `#3`, `#4`, `#5` |
| `idle` blink -> stand | `#6`, `#7`, `#8` |
| `idle` stand -> tail-sway | `#9`, `#10`, `#11` |
| `idle` tail-sway -> stand | `#12`, `#13`, `#14` |
| `hover` notice -> paw-probe | `#2`, `#3`, `#4` |
| `hover` paw-probe -> notice | `#5`, `#6`, `#7` |
| `tap` startle -> paw-probe | tap `#1`, `#2`, `#3` |
| `tap` paw-probe -> notice | tap `#4`, `#5`, `#6` |
| `tap` notice -> stand | tap `#7`, `#8`, `#9` |
| `sleep` loaf loop | sleep `#1`, `#2`, `#3`, `#4`, `#5`, `#6` |

## Interaction sequencing

```text
idle:
  stand -> head-lift -> pre-blink -> half-blink -> blink -> reopen -> breathe -> stand
  stand -> tail-pre -> tail-mid -> tail-full -> tail-sway -> tail-return -> stand

hover:
  notice -> ears-perk -> head-tilt -> forward-lean -> paw-probe -> paw-lift -> paw-hold -> recover -> notice

tap:
  startle -> alert-crouch -> hop-rise -> landing -> paw-probe -> paw-settle -> recover -> attention -> notice -> stand-recover -> neutral-step -> settle -> idle

sleep:
  lower -> tuck-paws -> settle -> loaf -> breathe-in -> breathe-out -> twitch -> loaf
```

## Quality notes

- Runtime assets are transparent PNG sprite sheets.
- Existing key poses are preserved as addressed subframes and supplemented with at least three transition subframes where the original sequence had a state-to-state transition.
- The manifest keeps `renderer.type` as `imageAssets`.
- The app window remains `320x340`, matching the sprite subframe canvas.
- `make validate` checks PNG dimensions directly and fails if a full-frame PNG or sprite-sheet subframe does not match the configured canvas.
