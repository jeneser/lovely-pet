# Getting Started

## 1. Run the sample pet from terminal

```bash
make validate
make run
```

The sample is a native macOS desktop pet. It uses PNG frame assets declared in `pet.json`; the procedural SwiftUI cat renderer has been removed.

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

## 4. Customize the pet

Edit:

```text
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json
```

Change the name, scale, window size, animation states, transition frames, and resource references. Add matching transparent PNG files under `frames/<state>/` and run `make validate` after every edit.
