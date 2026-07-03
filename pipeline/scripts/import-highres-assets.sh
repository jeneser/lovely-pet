#!/usr/bin/env bash
set -euo pipefail

python3 - <<'PY'
from pathlib import Path
from urllib.request import urlopen
url = 'https://drive.google.com/uc?export=download&id=1i7J-j1i32F1ygFTG9n8qQlCCP87PCp8j'
data = urlopen(url, timeout=60).read()
if not data.startswith(b'PK'):
    raise SystemExit('Drive response is not a zip file')
Path('/tmp/pet-frame-smooth-sheets.zip').write_bytes(data)
print(f'downloaded {len(data)} bytes')
PY

unzip -t /tmp/pet-frame-smooth-sheets.zip
unzip -o /tmp/pet-frame-smooth-sheets.zip -d .

python3 - <<'PY'
from pathlib import Path
path = Path('templates/macos-desktop-pet/Sources/LovelyPetApp/FrameAnimationPlayer.swift')
text = path.read_text()
text = text.replace('x: frameIndex * frameWidth,', 'x: CGFloat(frameIndex * frameWidth),')
text = text.replace('width: frameWidth,', 'width: CGFloat(frameWidth),')
text = text.replace('height: frameHeight', 'height: CGFloat(frameHeight)')
text = text.replace('NSSize(width: frameWidth, height: CGFloat(frameHeight))', 'NSSize(width: CGFloat(frameWidth), height: CGFloat(frameHeight))')
text = text.replace('NSSize(width: frameWidth, height: frameHeight)', 'NSSize(width: CGFloat(frameWidth), height: CGFloat(frameHeight))')
path.write_text(text)
PY

python3 pipeline/scripts/validate-pet-manifest.py templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json

python3 - <<'PY'
from pathlib import Path
from PIL import Image
root = Path('templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames')
expected = {'idle': (4800, 340), 'hover': (2560, 340), 'tap': (3200, 340), 'sleep': (2240, 340)}
for state, size in expected.items():
    got = Image.open(root / state / 'sheet.png').size
    print(state, got)
    if got != size:
        raise SystemExit(f'{state} expected {size}, got {got}')
PY

git config user.name 'github-actions[bot]'
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
git rm -f .github/workflows/import-highres-assets.yml .github/workflows/test-pull-request-trigger.yml .github/workflows/test-write-permission.yml pipeline/scripts/import-highres-assets.sh
git add pipeline/scripts/validate-pet-manifest.py templates/macos-desktop-pet/Sources/LovelyPetApp

git commit -m 'Replace pet sheets with high-res assets'
git push
