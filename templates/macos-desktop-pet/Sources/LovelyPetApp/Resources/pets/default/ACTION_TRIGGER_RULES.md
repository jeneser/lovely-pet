# Action trigger rules

The generated action sheets are now connected through the same `FrameAnimationPlayer` state system as `idle`, `hover`, `tap`, and `sleep`.

## Trigger model

| Trigger | Runtime sequence | Rationale |
|---|---|---|
| App start or recovery | `idle` | Stable standing/resting loop. |
| Pointer enters pet view | `hover` | Curiosity response. Hover only starts from `idle`, `hover`, or `sleep`, so it does not cut off a physical action halfway through. |
| Pointer leaves pet view | `idle` | Recovery from hover. |
| Single tap on head | `tap -> meow -> idle` | Touch first produces the existing tap response; then the cat vocalizes. |
| Single tap on paw area | `tap -> playPaperBall -> idle` | Paw interaction becomes a playful paw/toy response. |
| Single tap on tail area | `tap -> run -> idle` | Tail touch startles the cat, so a short run cycle is queued after tap feedback. |
| Single tap on body | `tap -> roll -> idle` | Body/rub interaction maps to a roll response, then returns to idle. |
| Double tap | `tap -> playPaperBall -> idle` | Stronger interaction maps to the richer toy animation. |
| Long press | `tap -> walk -> idle` | Long press suggests handled/moved pet; the cat takes a short step cycle and recovers. |
| Idle for about 18 seconds | one of `groom`, `meow`, `eat`, then `idle` | Natural ambient behavior while still awake. |
| Idle for about 45 seconds | `yawn -> idle` | Sleep-preparation cue before the real sleep threshold. |
| Idle for more than 60 seconds | `yawn -> sleep` | The player queues sleep after yawn so sleep does not snap directly from standing to sleeping. |

## Physical constraints

- Interaction actions are queued after `tap`, rather than replacing it, so the existing contact reaction remains visible.
- Ambient actions only start from `idle` or `hover`, never while another action is mid-flight.
- `yawn` is used as the transition into `sleep`; `sleep` then holds its sleeping loop.
- Short locomotion actions (`run`, `walk`) are self-contained and return to `idle`, because this PR does not yet move the pet window across the desktop.
- `roll` is also self-contained and returns to `idle`; it is only triggered from direct body interaction, not randomly from sleep.
