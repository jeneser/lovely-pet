# Roadmap

## 0.1 Ready-to-run demo

Done:

- Swift + AppKit desktop window.
- Asset-backed ragdoll demo based on transparent PNG frame sequences.
- Hover and tap feedback.
- Manifest validation.
- Basic app packaging.
- Documentation baseline.

## 0.2 Interaction depth

Done:

- Eye tracking toward cursor.
- Double-click special reaction.
- Idle timeout to sleep.
- Affection counter.
- Persistent affection through UserDefaults.
- Persistent scale setting through UserDefaults.
- Persistent window position through UserDefaults.
- Settings panel with scale control.
- Menu action to reset pet position.
- Petting zones for head, tail, paws, and body.
- Long-press hold reaction.
- Breathing, blinking, tail motion, hearts, sparkles, message bubble, and zone feedback.
- `CVDisplayLink` frame playback for PNG states.
- Transition frames between idle and hover.
- Dock walk with left/right animation states.

Remaining:

- Transparent-area hit testing.
- True drag-specific reaction while moving the window.
- Treat mini-game.

## 0.3 Asset-backed customer builds

Done:

- `frameSequence` renderer through `PetImageAssetView` and `FrameAnimationPlayer`.
- Customer asset injection shape through `pet.json`.
- QA-ready manifest validation for referenced frame files.
- Build artifact upload.

Next:

- Production asset QA report generation.
- Larger paid-build frame packs outside the lightweight sample set.

## 0.4 Commercial workflow

- Checkout integration.
- Order dashboard.
- Build status tracking.
- Signed and notarized customer downloads.

## 0.5 Premium animation

- Layered part renderer.
- Live2D or equivalent skeletal renderer adapter.
- Seasonal skins.
- Mood and daily rhythm system.
