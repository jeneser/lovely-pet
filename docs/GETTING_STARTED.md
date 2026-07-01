# Getting Started

## 1. Run the sample pet from terminal

```bash
make validate
make run
```

## 2. Open in Xcode

```bash
make xcode
```

Then select the `LovelyPetApp` scheme and run on `My Mac`. See `docs/XCODE_DEBUGGING.md` for the full debugging workflow.

## 3. Package the app

```bash
make package
open "templates/macos-desktop-pet/dist/Lovely Pet.app"
```

The sample is a native macOS desktop pet. It uses a procedural ragdoll cat renderer, so it runs immediately without external image assets.

## 4. Customize the pet

Edit:

```text
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json
```

Change the name, scale, animation states, and resource references. Run `make validate` after every edit.
