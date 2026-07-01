# Testing

## Local checks

Run these commands before creating a distributable build:

```bash
make validate
make build
make run
make package
```

## Manual QA checklist

- App launches without terminal errors.
- Pet window is transparent and floating.
- Pet can be dragged to a new position.
- Pet position persists after restarting the app.
- Menu bar Reset Position moves the pet back to the default area.
- Hover makes the pet lift, look alive, and track the cursor.
- Clicking the head, tail, paws, and body shows different messages or visual feedback.
- Tap makes the pet visibly react and then return to idle.
- Double tap shows stronger affection feedback.
- Long press triggers the hold/startled reaction.
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
- Memory use remains stable after several minutes of hover and tap testing.
- Deleting `Lovely Pet.app` removes the executable bundle.
- Optional local state cleanup removes `~/Library/Preferences/app.lovelypet.macos.plist`.

## Asset QA

- Pet name is correct.
- The pet still resembles the source animal.
- Private source photos are not committed to git unless they are intentionally public sample assets.
- Generated images have clean transparent edges.
- All expected animation states are present.
- External distribution builds should use a proper signing and notarization flow.
