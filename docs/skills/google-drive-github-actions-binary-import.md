# Google Drive to GitHub Actions binary asset import skill

Use this workflow when an automation agent cannot directly push PNG, ZIP, or other binary files through the GitHub connector. The reliable pattern is:

1. Upload the binary artifact to Google Drive.
2. Make the Drive file readable by anyone with the link.
3. Add a temporary import workflow and a temporary import script to a PR branch.
4. Let GitHub Actions download the Drive file, apply the binary changes, validate the repository, commit the generated files back to the PR branch, and remove the temporary workflow/script.
5. Confirm the final PR diff contains only the intended source/assets.

This is the same pattern used successfully for high-resolution pet frame imports and should be preferred for future binary asset writes.

## When to use

Use this skill for repository updates involving binary content such as:

- PNG sprite sheets or frame images
- ZIP asset bundles
- app icons, PDFs, audio files, or other non-text artifacts
- generated images that must remain sharp and not be downsampled

Do not try to send a large binary as base64 through the GitHub contents API unless the file is very small and there is no safer path.

## Preconditions

- The Drive file must be public-read: `anyone` + `reader`.
- The workflow must run with `contents: write` if it needs to push back to the PR branch.
- The workflow should target a fixed working branch, not the detached pull request merge ref.
- Temporary workflow/script files must be removed by the import commit.

## PR-branch workflow template

Create this file on the working PR branch, for example:

```text
.github/workflows/import-binary-asset-from-drive.yml
```

```yaml
name: Import binary asset from Drive

on:
  pull_request:
    branches: [main]
    paths:
      - .github/workflows/import-binary-asset-from-drive.yml
      - pipeline/scripts/import-binary-asset-from-drive.sh
  workflow_dispatch:

permissions:
  contents: write

jobs:
  import:
    if: github.actor != 'github-actions[bot]'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          # Use the real PR branch, not the generated merge ref.
          ref: YOUR_WORKING_BRANCH
          fetch-depth: 0

      - name: Import Drive asset
        run: bash pipeline/scripts/import-binary-asset-from-drive.sh
```

Replace `YOUR_WORKING_BRANCH` with the exact PR branch name, for example `fix-sleep-transition-sheet`.

## Import script template

Create this file on the same branch:

```text
pipeline/scripts/import-binary-asset-from-drive.sh
```

```bash
#!/usr/bin/env bash
set -euo pipefail

DRIVE_FILE_ID="REPLACE_WITH_PUBLIC_DRIVE_FILE_ID"
TARGET_PATH="templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/sleep/sleep-sheet.png"
MANIFEST_PATH="templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json"

python3 - <<'PY'
from pathlib import Path
from urllib.request import urlopen
import os

file_id = os.environ.get("DRIVE_FILE_ID") or "REPLACE_WITH_PUBLIC_DRIVE_FILE_ID"
url = f"https://drive.google.com/uc?export=download&id={file_id}"
data = urlopen(url, timeout=120).read()

# For ZIP imports use: if not data.startswith(b"PK")
# For PNG imports use: if not data.startswith(b"\x89PNG\r\n\x1a\n")
if not data.startswith(b"\x89PNG\r\n\x1a\n"):
    raise SystemExit(f"Drive response is not a PNG file: {data[:80]!r}")

Path("/tmp/imported-drive-asset.png").write_bytes(data)
print(f"downloaded {len(data)} bytes")
PY

# Example PNG replacement. For ZIP bundles, unzip into the repository instead.
cp /tmp/imported-drive-asset.png "$TARGET_PATH"

# Optional: update manifest with a small Python patch.
python3 - <<'PY'
from pathlib import Path
import json

manifest_path = Path("templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json")
manifest = json.loads(manifest_path.read_text())
manifest["states"]["sleep"]["frames"] = [
    "frames/sleep/sleep-sheet.png#0",
    "frames/sleep/sleep-sheet.png#1",
    "frames/sleep/sleep-sheet.png#2",
    "frames/sleep/sleep-sheet.png#3",
    "frames/sleep/sleep-sheet.png#4",
    "frames/sleep/sleep-sheet.png#5",
    "frames/sleep/sleep-sheet.png#6",
    "frames/sleep/sleep-sheet.png#6",
]
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
PY

python3 pipeline/scripts/validate-pet-manifest.py "$MANIFEST_PATH"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

# Remove temporary import files so they do not remain in the PR diff.
git rm -f \
  .github/workflows/import-binary-asset-from-drive.yml \
  pipeline/scripts/import-binary-asset-from-drive.sh

git add "$TARGET_PATH" "$MANIFEST_PATH"
git commit -m "Import binary asset from Drive"
git push
```

## ZIP bundle variant

Use this when the Drive file is a ZIP containing a repository-relative overlay:

```bash
python3 - <<'PY'
from pathlib import Path
from urllib.request import urlopen

file_id = "REPLACE_WITH_PUBLIC_DRIVE_FILE_ID"
url = f"https://drive.google.com/uc?export=download&id={file_id}"
data = urlopen(url, timeout=120).read()
if not data.startswith(b"PK"):
    raise SystemExit(f"Drive response is not a zip file: {data[:80]!r}")
Path("/tmp/assets.zip").write_bytes(data)
print(f"downloaded {len(data)} bytes")
PY

unzip -t /tmp/assets.zip
unzip -o /tmp/assets.zip -d .
```

After unzipping, run repository validation and commit only the intended files.

## Review checklist

Before merging the PR:

- Confirm the temporary workflow and import script are gone from the final diff.
- Confirm the final diff contains only intended files.
- Confirm image dimensions and frame counts are correct.
- Confirm `pet.json` does not loop from the final sleeping frame back to the standing frame unless explicitly intended.
- Confirm CI is either successful or only waiting for manual approval/action due to bot-triggered workflow rules.

## Known pitfalls

- A workflow newly added only on a PR branch may not run in the way a normal branch workflow does. Use the pull request pattern above and approve/run it in the GitHub UI when requested.
- `actions/checkout` must check out the actual branch to push back to it.
- Keep temporary import files in the trigger path so the PR event sees the workflow/script change.
- For generated PNGs, preserve resolution. PNG compression level changes are lossless, but do not downsample or convert to JPEG.
