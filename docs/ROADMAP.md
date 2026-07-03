# Roadmap

## 0.1 Ready-to-run demo

- Swift + AppKit desktop window.
- PNG frame-sequence ragdoll demo loaded from bundled resources.
- Hover and tap feedback.
- Manifest validation.
- Basic app packaging.
- Documentation baseline.

## 0.2 Interaction depth

Done:

- Cursor-aware movement.
- Double-click special heart-burst reaction.
- Idle timeout to sleep.
- Persistent scale setting through UserDefaults.
- Persistent window position through UserDefaults.
- Settings panel with scale control that resizes the pet view and window together.
- Status bar menu simplified to Settings and Quit.
- Long-press hold reaction.
- Frame-state changes, hearts, sparkles, message bubble, and zone feedback.
- Removed affection counter display and click-based affection increments.

Remaining:

- Transparent-area hit testing.
- True drag-specific reaction while moving the window.
- Treat mini-game.

## 0.3 Asset-backed builds

- Extend the `imageAssets` PNG frame renderer.
- Asset injection script.
- QA report generation.
- Build artifact upload.

## 0.4 Distribution workflow

- Release packaging checklist.
- Build status tracking.
- Signed and notarized downloads when needed.
- Clear install, first-open, quit, and removal guidance.

## 0.5 Premium animation

- Layered part renderer.
- Live2D or equivalent skeletal renderer adapter.
- Seasonal skins.
- Mood and daily rhythm system.
