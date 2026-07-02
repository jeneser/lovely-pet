# Runtime Safety Notes

This document describes what the packaged macOS app does on a local machine and how to remove its local state.

## What the app does

- Runs as a normal user-space macOS app.
- Shows a transparent desktop pet window above the Dock window level.
- Adds a menu bar item with Show, Reset Position, Toggle Dock Walk, Settings, and Quit controls.
- Uses checked-in PNG frame assets for the sample pet; no external renderer process is started.
- Uses `UserDefaults` for small local preferences.
- Does not install a LaunchAgent, daemon, login item, kernel extension, browser extension, or background service.
- Does not require Node, Python, or any runtime after the app is packaged.
- Does not perform network requests in the current runtime.

## Local data written

The app stores only small preference values through `UserDefaults`:

```text
lovelyPet.app.affection
lovelyPet.app.scale
lovelyPet.app.window.x
lovelyPet.app.window.y
```

With the current bundle identifier, macOS stores these values in the app preferences domain:

```text
~/Library/Preferences/app.lovelypet.macos.plist
```

## Removing the app

To remove the app:

1. Quit the app from the menu bar item.
2. Delete `Lovely Pet.app`.
3. Optionally delete the preference file:

```bash
rm -f ~/Library/Preferences/app.lovelypet.macos.plist
```

You can also use Settings -> Reset Stored Data before deleting the app.

## Stop and recovery

- Normal stop: menu bar -> Quit.
- If the menu is inaccessible: use Activity Monitor and quit `LovelyPetApp`.
- The app has no restart mechanism, so it will not relaunch itself after being quit.

## Performance safeguards

- Image frame playback is paced by `CVDisplayLink` and throttled to the manifest fps for each state.
- All manifest frames are preloaded into an `NSCache` at launch to avoid first-interaction disk I/O spikes.
- macOS Reduce Motion is respected by the SwiftUI overlay transforms; the source PNG frame state remains available.
- The idle sleep check runs only once every 10 seconds.
- Dock walk uses a 60 Hz position timer only while the menu-controlled walk mode is enabled.

## Known limitations

- Current builds are ad-hoc signed, not Developer ID notarized. macOS may show the normal first-open security warning for downloaded apps.
- Transparent-area hit testing is not implemented yet; the window uses a rectangular hit area.
- Final CPU and memory numbers should be verified on target Mac hardware through Activity Monitor.
