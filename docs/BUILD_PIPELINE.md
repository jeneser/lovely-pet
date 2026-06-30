# Build Pipeline

## Goal

Create a repeatable pipeline that turns one approved pet resource folder into a customer-specific macOS `.app` without requiring the customer to install Node, Python, or a developer environment.

## Inputs

```text
customer-order.json
pet.json
frames/
  idle/*.png
  hover/*.png
  tap/*.png
```

## Output

```text
customer-builds/<order-id>/
  LovelyPet-<pet-name>.app
  LovelyPet-<pet-name>.zip
  manifest.json
  qa-report.md
```

## Pipeline Steps

1. Validate customer order data.
2. Validate `pet.json` against `pipeline/schemas/pet.schema.json`.
3. Validate all referenced animation frames exist.
4. Copy the macOS template.
5. Inject pet assets into `Resources/pets/<pet-id>`.
6. Build with Swift Package Manager or Xcode.
7. Package app bundle.
8. Codesign.
9. Notarize if distributing outside the Mac App Store.
10. Zip and deliver.

## MVP Implementation

The MVP script `pipeline/scripts/build-macos-app.sh` is intentionally conservative. It prepares the directory structure and calls Swift build. A production version should add app bundle generation, signing identities, hardened runtime, notarization, and artifact upload.

## Production Notes

- Keep AI generation outside the app template.
- Keep payment secrets outside this repository.
- Keep raw customer photos private and avoid committing them by default.
- Commit only demo-safe sample assets.
- Store paid order artifacts in private object storage.
