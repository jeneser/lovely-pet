# Getting Started

## 1. Run the demo

```bash
make validate
make run
```

## 2. Package the app

```bash
make package
open "templates/macos-desktop-pet/dist/Lovely Pet Demo.app"
```

The demo is a native macOS desktop pet. It uses a procedural ragdoll cat renderer, so it runs immediately without external image assets.

## 3. Customize the pet

Edit:

```text
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/ragdoll-demo/pet.json
```

Change the window size, state durations, and keyframes. Run `make validate` after every edit.
