# Getting Started

## 1. Run the sample pet

```bash
make validate
make run
```

## 2. Package the app

```bash
make package
open "templates/macos-desktop-pet/dist/Lovely Pet.app"
```

The sample is a native macOS desktop pet. It uses a procedural ragdoll cat renderer, so it runs immediately without external image assets.

## 3. Customize the pet

Edit:

```text
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json
```

Change the name, scale, animation states, and resource references. Run `make validate` after every edit.
