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
- After a quiet period, the pet can enter sleepy visual state.
- Menu bar item remains available.
- Quit works from the menu.
- Packaged app opens from `templates/macos-desktop-pet/dist/Lovely Pet.app`.

## Asset QA

- Pet name is correct.
- The pet still resembles the source animal.
- Private source photos are not committed to git unless they are intentionally public sample assets.
- Generated images have clean transparent edges.
- All expected animation states are present.
- External distribution builds should use a proper signing and notarization flow.
