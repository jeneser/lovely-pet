# Testing

## Local checks

Run these commands before creating a distributable build:

```bash
make validate
make compat
make build
make run
make package
```

## Manual QA checklist

- App launches without terminal errors.
- Pet window is transparent and floating above the Dock.
- Pet can be dragged to a new position.
- Pet position persists after restarting the app.
- Menu bar Reset Position moves the pet back to the default area.
- Hover changes to the hover PNG loop without a hard visual cut.
- Leaving hover plays transition frames and returns to idle.
- Clicking the head, tail, paws, and body shows different messages or visual feedback.
- Tap makes the pet visibly react and then return to idle.
- Double tap shows stronger affection feedback.
- Long press triggers the hold/startled reaction.
- Toggle Dock Walk moves the pet along the Dock top edge and switches between `walk_right` and `walk_left`.
- Affection count increases and persists after restarting the app.
- Scale can be changed from Settings and persists after restart.
- Settings -> Reset Stored Data clears affection, saved scale, and saved window position.
- After a quiet period, the pet can enter sleepy visual state.
- Menu bar item remains available.
- Quit works from the menu.
- Packaged app opens from `templates/macos-desktop-pet/dist/Lovely Pet.app`.

## Runtime safety checklist

- Activity Monitor shows only one `LovelyPetApp` process while the app is running.
- Quit from the menu bar stops the process.
- The app does not relaunch itself after Quit.
- CPU use stays modest while idle.
- Memory use remains stable after several minutes of hover, tap, and Dock walk testing.
- Deleting `Lovely Pet.app` removes the executable bundle.
- Optional local state cleanup removes `~/Library/Preferences/app.lovelypet.macos.plist`.

## Asset QA

- Pet name is correct.
- The pet still resembles the source animal.
- Private source photos are not committed to git unless they are intentionally public sample assets.
- Generated images have clean transparent edges.
- All expected animation states are present and referenced by `pet.json`.
- External distribution builds should use a proper signing and notarization flow.
