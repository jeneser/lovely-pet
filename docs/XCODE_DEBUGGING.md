# Xcode Debugging

Lovely Pet is a Swift Package, so it can be opened directly in Xcode without committing a generated `.xcodeproj` file.

## Open in Xcode

From the repository root:

```bash
make xcode
```

Or open the package directly:

```bash
xed templates/macos-desktop-pet
```

If `xed` is unavailable:

```bash
open templates/macos-desktop-pet/Package.swift
```

## Run from Xcode

1. Select the `LovelyPetApp` scheme.
2. Select `My Mac` as the destination.
3. Press `Run`.
4. The app runs as a menu-bar accessory app, so look for the paw icon in the macOS menu bar.
5. Use the menu-bar item to open Settings, reset position, or quit.

## Debugging notes

- Breakpoints work in the Swift files under `Sources/LovelyPetApp`.
- The app entry point is `LovelyPetApplication.swift`.
- The package no longer relies on a SwiftPM resource bundle for pet resources.
- `PetResourceLocator` searches both packaged-app resources and source-tree resources, so Xcode debugging works even when the working directory differs from terminal `swift run`.
- The GitHub Actions and command-line build path still use the same `Package.swift` and `make package` flow.

## Local data while debugging

The app stores small preferences in `UserDefaults`:

```text
lovelyPet.app.scale
lovelyPet.app.window.x
lovelyPet.app.window.y
```

Settings -> Reset Stored Data also clears the legacy `lovelyPet.app.affection` key from older builds.

## Why there is no checked-in .xcodeproj

Xcode has native Swift Package support. Committing a generated project file would add a large, fragile file that can drift from `Package.swift`. Keeping the package as the source of truth makes local debugging, CI, and release packaging use the same build definition.
