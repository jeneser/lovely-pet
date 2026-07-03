---
name: google-drive-github-actions-binary-import
description: Import PNG, ZIP, and other binary artifacts into a GitHub PR branch through a public Google Drive file and a temporary GitHub Actions workflow when direct binary writes through connectors are unavailable.
---

# Google Drive to GitHub Actions binary asset import

Use this skill when an automation agent cannot directly push PNG, ZIP, or other binary files through the GitHub connector. The reliable pattern is:

1. Upload the binary artifact to Google Drive.
2. Make the Drive file readable by anyone with the link.
3. Add a temporary import workflow and a temporary import script to the PR branch.
4. Let GitHub Actions download the Drive file, apply the binary changes, validate the repository, commit the generated files back to the PR branch, and remove the temporary workflow/script.
5. Confirm the final PR diff contains only the intended source/assets.

This pattern has been verified in this repository for both high-resolution frame-sheet imports and the `sleep-sheet.png` replacement in PR #11. Prefer it for future binary asset writes.

## When to use

Use this skill for repository updates involving binary content such as:

- PNG sprite sheets or frame images.
- ZIP asset bundles.
- app icons, PDFs, audio files, or other non-text artifacts.
- generated images that must remain sharp and not be downsampled.

Do not try to send a large binary as base64 through the GitHub contents API unless the file is very small and there is no safer path.

## Preconditions

- The Drive file must be public-read: `anyone` + `reader`.
- The workflow must run with `contents: write` if it needs to push back to the PR branch.
- The workflow must check out the real PR branch, not the detached pull request merge ref.
- Temporary workflow/script files must be removed by the import commit.
- Expect GitHub UI manual approval or an `action_required` CI state after bot-triggered commits. That is not automatically a code failure.

## Critical lessons learned

The failure mode to avoid is creating a `push` workflow only on the PR branch and expecting it to run immediately and push back to the same branch. New workflow files added only in a branch do not behave like an already-present default-branch workflow, and the import may never run.

The successful pattern is a `pull_request` workflow committed to the PR branch, with `paths` limited to the temporary workflow and temporary import script. When the PR updates, GitHub sees the workflow/script changes, runs the workflow after approval if required, checks out the fixed head branch, imports the binary, validates it, commits the real assets, and deletes the temporary files in the same commit.

For PR #11, this exact pattern succeeded:

- Temporary workflow: `.github/workflows/import-sleep-sheet-from-drive.yml`.
- Temporary script: `pipeline/scripts/import_sleep_sheet_from_drive.py`.
- Drive source file: `sleep-sheet-generated-source.png`.
- Run name: `Import sleep sheet from Drive`.
- Import run result: `success`.
- Final PR diff: only `sleep-sheet.png` and `pet.json`.
- Temporary workflow and script were removed automatically by the import commit.

## PR-branch workflow template

Create this file on the working PR branch, for example:

```text
.github/workflows/import-binary-asset-from-drive.yml
```

```yaml
name: Import binary asset from Drive

on:
  pull_request:
    branches:
      - main
    paths:
      - .github/workflows/import-binary-asset-from-drive.yml
      - pipeline/scripts/import-binary-asset-from-drive.sh

permissions:
  contents: write
  pull-requests: read

jobs:
  import:
    # Prevent follow-up bot commits from re-running the importer forever.
    if: github.actor != 'github-actions[bot]' && github.event.pull_request.head.ref == 'YOUR_WORKING_BRANCH'
    runs-on: ubuntu-latest
    steps:
      - name: Checkout PR branch
        uses: actions/checkout@v4
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
TEMP_WORKFLOW=".github/workflows/import-binary-asset-from-drive.yml"
TEMP_SCRIPT="pipeline/scripts/import-binary-asset-from-drive.sh"

python3 - <<'PY'
from pathlib import Path
from urllib.request import Request, urlopen
import os

file_id = os.environ.get("DRIVE_FILE_ID") or "REPLACE_WITH_PUBLIC_DRIVE_FILE_ID"
url = f"https://drive.usercontent.google.com/download?id={file_id}&export=download&confirm=t"
request = Request(url, headers={"User-Agent": "Mozilla/5.0"})
data = urlopen(request, timeout=120).read()

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
manifest["states"]["sleep"]["fps"] = 2
manifest["states"]["sleep"]["loop"] = True
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
git rm -f "$TEMP_WORKFLOW" "$TEMP_SCRIPT"

git add "$TARGET_PATH" "$MANIFEST_PATH"
git commit -m "Import binary asset from Drive"
git push
```

## Python importer variant for generated sprite sheets

Use a Python script instead of a shell-only copy when the Drive file is a generated preview sheet that needs normalization, background removal, resizing, or manifest edits before committing.

This is the pattern that fixed the sleep sheet replacement:

```yaml
name: Import sleep sheet from Drive

on:
  pull_request:
    branches:
      - main
    paths:
      - .github/workflows/import-sleep-sheet-from-drive.yml
      - pipeline/scripts/import_sleep_sheet_from_drive.py

permissions:
  contents: write
  pull-requests: read

jobs:
  import-sleep-sheet:
    if: github.event.pull_request.head.ref == 'fix-sleep-transition-sheet'
    runs-on: ubuntu-latest
    steps:
      - name: Checkout PR branch
        uses: actions/checkout@v4
        with:
          ref: fix-sleep-transition-sheet
          fetch-depth: 0

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install image tooling
        run: |
          python -m pip install --upgrade pip
          python -m pip install pillow numpy scipy opencv-python-headless

      - name: Import sleep sheet from Google Drive
        run: python pipeline/scripts/import_sleep_sheet_from_drive.py

      - name: Validate pet manifest
        run: python pipeline/scripts/validate-pet-manifest.py templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json

      - name: Commit imported sleep sheet and cleanup
        uses: stefanzweifel/git-auto-commit-action@v5
        with:
          commit_message: Replace sleep sheet with Drive image
          branch: fix-sleep-transition-sheet
          file_pattern: templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/sleep/sleep-sheet.png templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json .github/workflows/import-sleep-sheet-from-drive.yml pipeline/scripts/import_sleep_sheet_from_drive.py
```

Important details from the successful run:

- Use `drive.usercontent.google.com/download?id=<FILE_ID>&export=download&confirm=t` and set a normal browser `User-Agent` when downloading public Drive files.
- Install image dependencies in the runner if the script uses Pillow, NumPy, SciPy, or OpenCV.
- The Python script should delete both the temporary workflow and itself before the auto-commit step.
- The auto-commit `file_pattern` must include both production outputs and temporary files; otherwise removed temporary files may not be committed.
- After the import commit, fetch the PR again and verify `changed_files` is back to the intended final count.

## ZIP bundle variant

Use this when the Drive file is a ZIP containing a repository-relative overlay:

```bash
python3 - <<'PY'
from pathlib import Path
from urllib.request import Request, urlopen

file_id = "REPLACE_WITH_PUBLIC_DRIVE_FILE_ID"
url = f"https://drive.usercontent.google.com/download?id={file_id}&export=download&confirm=t"
request = Request(url, headers={"User-Agent": "Mozilla/5.0"})
data = urlopen(request, timeout=120).read()
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

- Confirm the import workflow run completed with `success`.
- Confirm logs show the Drive artifact downloaded with a plausible byte count.
- Confirm the temporary workflow and import script are gone from the final diff.
- Confirm the final diff contains only intended files.
- Confirm image dimensions and frame counts are correct.
- Confirm `pet.json` does not loop from the final sleeping frame back to the standing frame unless explicitly intended.
- Confirm CI is either successful or only waiting for manual approval/action due to bot-triggered workflow rules.
- For PNG replacements, compare the final repository blob SHA or generated file hash when possible.

## Known pitfalls

- Do not rely on a newly added `push` workflow on a PR branch to perform the import. Use the `pull_request` + `paths` pattern and approve/run it in the GitHub UI when requested.
- `actions/checkout` must check out the actual branch to push back to it.
- Keep temporary import files in the trigger path so the PR event sees the workflow/script change.
- If the Drive file is public but download still fails, use the `drive.usercontent.google.com/download` URL and include a `User-Agent` header.
- For generated PNGs, preserve resolution. PNG compression level changes are lossless, but do not downsample or convert to JPEG.
- Do not merge while temporary workflow/script files remain in the PR diff.
