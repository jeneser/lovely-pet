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
- Hover makes the pet visibly react.
- Tap makes the pet visibly react and then return to idle.
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
