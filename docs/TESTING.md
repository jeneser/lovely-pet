# Testing

## Local checks

Run these commands before shipping a customer build:

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
- Packaged app opens from `dist/`.

## Customer build QA

- Pet name is correct.
- The pet still resembles the source animal.
- No private customer photos are committed to git.
- Generated images have clean transparent edges.
- All expected animation states are present.
- The app is signed and notarized for paid external distribution.
