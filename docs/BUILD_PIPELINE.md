# Build Pipeline

## Goal

Build one approved pet resource folder into a standalone macOS `.app` without requiring the end user to install Node, Python, or a developer environment.

## Commands

```bash
make validate
make build
make package
```

`make package` calls:

```text
templates/macos-desktop-pet/scripts/package-app.sh
```

The script builds the Swift executable, creates an app bundle directory, copies the executable, copies the Info.plist template, copies pet resources into the bundle, signs ad-hoc when possible, and creates a zip archive.

## Inputs

```text
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/
```

## Outputs

```text
templates/macos-desktop-pet/dist/Lovely Pet.app
templates/macos-desktop-pet/dist/Lovely-Pet-macOS.zip
```

## Recommended release flow

1. Validate `pet.json`.
2. Validate image assets and animation states.
3. Build the Swift template.
4. Create the `.app` bundle.
5. Sign and notarize for external distribution when needed.
6. Compress the app bundle.
7. Upload the zip as a CI artifact or Release asset.

## Notes

- Keep generation workflows outside the app runtime.
- Keep private source photos out of git unless they are intentionally public sample assets.
- Commit only small, reviewable sample assets.
- Use GitHub Actions artifacts for quick testing builds.
