# Build Pipeline

## Goal

Build one approved pet resource folder into a customer-specific macOS `.app` without requiring the customer to install Node, Python, or a developer environment.

## MVP commands

```bash
make validate
make build
make package
```

`make package` calls:

```text
templates/macos-desktop-pet/scripts/package-app.sh
```

The script builds the Swift executable, creates an app bundle directory, copies the executable, copies the Info.plist template, and copies pet resources into the bundle.

## Inputs

```text
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/
```

## Output

```text
templates/macos-desktop-pet/dist/Lovely Pet Demo.app
```

## Production pipeline

1. Validate customer order data.
2. Validate `pet.json`.
3. Validate image assets and animation states.
4. Copy the macOS template.
5. Inject customer pet assets.
6. Build the Swift template.
7. Create the `.app` bundle.
8. Sign with Developer ID.
9. Notarize for external distribution.
10. Compress, upload, and deliver a secure download link.

## Production notes

- Keep AI generation outside the app template.
- Keep payment secrets outside this repository.
- Keep raw customer photos private and avoid committing them by default.
- Commit only demo-safe sample assets.
- Store paid order artifacts in private object storage.
