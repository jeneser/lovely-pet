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
- Status bar menu shows Settings and Quit.
- Settings opens from the status bar menu.
- Hover makes the pet lift, look alive, and track the cursor.
- Clicking the head, tail, paws, and body shows different visual feedback.
- Tap makes the pet visibly react and then return to idle.
- Double tap shows stronger heart-burst feedback without showing a text bubble.
- Tap and double tap do not show or persist an affection/heart count.
- Long press or drag triggers the hold/startled reaction.
- Scale can be changed from Settings and persists after restart.
- Changing scale resizes the pet image and transparent window together; the pet is not clipped at 0.6x, 1.0x, or 1.8x.
- Settings -> Reset Stored Data clears saved scale and saved window position.
- After a quiet period, the pet can enter sleepy visual state.
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
- Every PNG frame or sprite-sheet subframe matches the `pet.json` window canvas size.
- External distribution builds should use a proper signing and notarization flow.
