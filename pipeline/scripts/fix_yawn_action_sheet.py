#!/usr/bin/env python3
from __future__ import annotations

import json
import shutil
import zipfile
from pathlib import Path
from urllib.request import Request, urlopen

from PIL import Image
import numpy as np
from scipy import ndimage as ndi

DRIVE_FILE_ID = "1JIeNnddO7bU8brgXlXrhX4oFHPkYfahk"
PET_ROOT = Path("templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default")
TARGET = PET_ROOT / "frames/yawn/yawn-20f-sheet.png"
ACTION_MAP = PET_ROOT / "ACTION_SPRITE_MAP.md"
TEMP_WORKFLOW = Path(".github/workflows/fix-yawn-action-sheet-from-drive.yml")
TEMP_SCRIPT = Path("pipeline/scripts/fix_yawn_action_sheet.py")

FRAME_WIDTH = 320
FRAME_HEIGHT = 340
FRAME_COUNT = 20
MAX_SPRITE_WIDTH = 220
MAX_SPRITE_HEIGHT = 260
BOTTOM_MARGIN = 20


def download_drive_zip(destination: Path) -> None:
    url = f"https://drive.usercontent.google.com/download?id={DRIVE_FILE_ID}&export=download&confirm=t"
    request = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    data = urlopen(request, timeout=180).read()
    if not data.startswith(b"PK"):
        raise SystemExit(f"Drive response is not a ZIP file: {data[:80]!r}")
    destination.write_bytes(data)
    print(f"downloaded {len(data)} bytes")


def foreground_mask(rgb: Image.Image) -> np.ndarray:
    arr = np.asarray(rgb.convert("RGB"), dtype=np.int16)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    mx = arr.max(axis=2)
    background = (np.abs(r - g) <= 12) & (np.abs(r - b) <= 12) & (np.abs(g - b) <= 12) & (mx >= 236)
    return ~background


def yawn_components(mask: np.ndarray) -> list[dict[str, object]]:
    labels, count = ndi.label(mask, structure=np.ones((3, 3), dtype=np.uint8))
    components: list[dict[str, object]] = []
    for label in range(1, count + 1):
        selected = labels == label
        area = int(selected.sum())
        if area < 1000:
            continue
        ys, xs = np.where(selected)
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        y0, y1 = int(ys.min()), int(ys.max()) + 1
        if x1 - x0 < 30 or y1 - y0 < 50:
            continue
        components.append(
            {
                "label": label,
                "area": area,
                "box": (x0, y0, x1, y1),
                "center_x": (x0 + x1) / 2,
            }
        )
    components.sort(key=lambda c: float(c["center_x"]))
    if len(components) < 2:
        raise SystemExit(f"not enough yawn components detected: {len(components)}")
    return components


def regenerate_yawn(source_path: Path) -> dict[str, object]:
    rgb = Image.open(source_path).convert("RGB")
    mask = foreground_mask(rgb)
    labels, _ = ndi.label(mask, structure=np.ones((3, 3), dtype=np.uint8))
    components = yawn_components(mask)

    # The generated yawn source currently contains 19 clean detected cat components.
    # The runtime contract requires 20 frames, so resample by duplicating one adjacent
    # peak/open-mouth component. This is safer than the previous generic importer,
    # which expanded the first runtime frame to include three source cats.
    source_indexes = [round(i * (len(components) - 1) / (FRAME_COUNT - 1)) for i in range(FRAME_COUNT)]

    rgba = rgb.convert("RGBA")
    frames = []
    frame_reports = []
    for frame_index, component_index in enumerate(source_indexes):
        component = components[component_index]
        label = int(component["label"])
        x0, y0, x1, y1 = component["box"]
        padding = 6
        x0 = max(0, x0 - padding)
        y0 = max(0, y0 - padding)
        x1 = min(rgb.width, x1 + padding)
        y1 = min(rgb.height, y1 + padding)
        crop = rgba.crop((x0, y0, x1, y1))
        component_alpha = (labels[y0:y1, x0:x1] == label).astype("uint8") * 255
        crop.putalpha(Image.fromarray(component_alpha, mode="L"))
        frames.append(crop)
        frame_reports.append(
            {
                "index": frame_index,
                "source_component_index": component_index,
                "source_box": [x0, y0, x1, y1],
            }
        )

    max_width = max(frame.width for frame in frames)
    max_height = max(frame.height for frame in frames)
    scale = min(MAX_SPRITE_WIDTH / max_width, MAX_SPRITE_HEIGHT / max_height)
    output = Image.new("RGBA", (FRAME_WIDTH * FRAME_COUNT, FRAME_HEIGHT), (0, 0, 0, 0))

    for index, frame in enumerate(frames):
        size = (max(1, round(frame.width * scale)), max(1, round(frame.height * scale)))
        resized = frame.resize(size, Image.Resampling.LANCZOS)
        frame_left = index * FRAME_WIDTH
        paste_x = frame_left + (FRAME_WIDTH - resized.width) // 2
        paste_y = FRAME_HEIGHT - BOTTOM_MARGIN - resized.height
        if paste_x < frame_left or paste_x + resized.width > frame_left + FRAME_WIDTH or paste_y < 0:
            raise SystemExit(f"yawn frame {index} does not fit runtime canvas: size={size}, paste=({paste_x},{paste_y})")
        output.alpha_composite(resized, (paste_x, paste_y))
        frame_reports[index]["render_size"] = list(size)
        frame_reports[index]["paste_xy"] = [paste_x, paste_y]

    TARGET.parent.mkdir(parents=True, exist_ok=True)
    output.save(TARGET, optimize=False, compress_level=6)
    return {
        "source": str(source_path),
        "target": str(TARGET),
        "detected_components": len(components),
        "source_indexes": source_indexes,
        "output_size": list(output.size),
        "max_source_crop_size": [max_width, max_height],
        "scale": round(scale, 4),
        "frames": frame_reports,
    }


def update_action_map(report: dict[str, object]) -> None:
    text = ACTION_MAP.read_text(encoding="utf-8")
    marker = "\n## Precision follow-up\n"
    if marker in text:
        text = text.split(marker, 1)[0].rstrip() + "\n"
    lines = [
        "## Precision follow-up",
        "",
        "The `yawn` sheet was regenerated with action-specific component isolation. The generic importer had allowed the first runtime frame to contain multiple adjacent source cats. The fixed sheet selects exactly one detected yawn component per frame, rescales it into a centered `320x340` slot, and keeps the runtime sheet at `6400x340`.",
        "",
        "```json",
        json.dumps(report, ensure_ascii=False, indent=2),
        "```",
        "",
    ]
    ACTION_MAP.write_text(text.rstrip() + "\n" + "\n".join(lines), encoding="utf-8")


def cleanup() -> None:
    for path in (TEMP_WORKFLOW, TEMP_SCRIPT):
        if path.exists():
            path.unlink()


def main() -> int:
    zip_path = Path("/tmp/cat_action_sprites_20f_row.zip")
    extract_dir = Path("/tmp/cat_action_sprites_20f_row")
    if extract_dir.exists():
        shutil.rmtree(extract_dir)
    extract_dir.mkdir(parents=True)
    download_drive_zip(zip_path)
    with zipfile.ZipFile(zip_path) as archive:
        archive.testzip()
        archive.extractall(extract_dir)
    matches = list(extract_dir.rglob("yawn_20f_row.png"))
    if not matches:
        raise SystemExit("missing yawn_20f_row.png in Drive bundle")
    report = regenerate_yawn(matches[0])
    update_action_map(report)
    cleanup()
    print("fixed yawn action sheet")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
