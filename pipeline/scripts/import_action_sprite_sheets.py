#!/usr/bin/env python3
from __future__ import annotations

import json
import math
import shutil
import sys
import zipfile
from dataclasses import dataclass
from pathlib import Path
from urllib.request import Request, urlopen

from PIL import Image, ImageFilter
import numpy as np
from scipy import ndimage as ndi

DRIVE_FILE_ID = "1JIeNnddO7bU8brgXlXrhX4oFHPkYfahk"
PET_ROOT = Path("templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default")
MANIFEST_PATH = PET_ROOT / "pet.json"
ASSET_MAP_PATH = PET_ROOT / "ASSET_POSE_MAP.md"
ACTION_MAP_PATH = PET_ROOT / "ACTION_SPRITE_MAP.md"
TEMP_WORKFLOW = Path(".github/workflows/import-action-sprite-sheets-from-drive.yml")
TEMP_SCRIPT = Path("pipeline/scripts/import_action_sprite_sheets.py")
FRAME_WIDTH = 320
FRAME_HEIGHT = 340
FRAME_COUNT = 20
MAX_SPRITE_WIDTH = 280
MAX_SPRITE_HEIGHT = 260
BOTTOM_MARGIN = 20

@dataclass(frozen=True)
class ActionSpec:
    state: str
    source: str
    target: Path
    fps: int
    loop: bool
    next_state: str | None
    role: str

ACTIONS = [
    ActionSpec("eat", "eat_20f_row.png", Path("frames/eat/eat-20f-sheet.png"), 8, False, "idle", "Approach food, eat, lift head, and settle back to an idle-compatible pose."),
    ActionSpec("playPaperBall", "play_paper_ball_20f_row.png", Path("frames/play-paper-ball/play-paper-ball-20f-sheet.png"), 10, False, "idle", "Notice, paw, crouch, pounce, and recover beside the paper ball."),
    ActionSpec("roll", "roll_20f_row.png", Path("frames/roll/roll-20f-sheet.png"), 8, True, None, "Continuous floor roll / belly-up loop; kept looping to avoid a direct lying-to-standing snap."),
    ActionSpec("groom", "groom_20f_row.png", Path("frames/groom/groom-20f-sheet.png"), 8, False, "idle", "Sit, lower head, lick chest/paw, wipe face, and return to idle-compatible sitting."),
    ActionSpec("run", "run_20f_row.png", Path("frames/run/run-20f-sheet.png"), 12, True, None, "Loopable side-view running cycle."),
    ActionSpec("walk", "walk_20f_row.png", Path("frames/walk/walk-20f-sheet.png"), 8, True, None, "Loopable side-view walking cycle."),
    ActionSpec("yawn", "yawn_20f_row.png", Path("frames/yawn/yawn-20f-sheet.png"), 8, False, "idle", "Idle-compatible sitting yawn that opens, peaks, closes, and returns to calm."),
    ActionSpec("meow", "meow_20f_row.png", Path("frames/meow/meow-20f-sheet.png"), 8, False, "idle", "Idle-compatible meow expression cycle that returns to calm."),
]


def download_drive_zip(destination: Path) -> None:
    urls = [
        f"https://drive.usercontent.google.com/download?id={DRIVE_FILE_ID}&export=download&confirm=t",
        f"https://drive.google.com/uc?export=download&id={DRIVE_FILE_ID}&confirm=t",
    ]
    last_error: Exception | None = None
    for url in urls:
        try:
            request = Request(url, headers={"User-Agent": "Mozilla/5.0"})
            data = urlopen(request, timeout=180).read()
            if data.startswith(b"PK"):
                destination.write_bytes(data)
                print(f"downloaded {len(data)} bytes from Google Drive")
                return
            print(f"Drive response was not a zip from {url}: {data[:80]!r}")
        except Exception as exc:  # noqa: BLE001
            last_error = exc
            print(f"download failed from {url}: {exc}")
    raise SystemExit(f"Could not download ZIP from Google Drive: {last_error}")


def find_bundle_root(extract_dir: Path) -> Path:
    direct = extract_dir / "cat_action_sprites_20f_row"
    if direct.is_dir():
        return direct
    matches = [p.parent for p in extract_dir.rglob("eat_20f_row.png")]
    if not matches:
        raise SystemExit("ZIP bundle does not contain eat_20f_row.png")
    return matches[0]


def foreground_alpha(rgb: Image.Image) -> Image.Image:
    arr = np.asarray(rgb.convert("RGB"), dtype=np.int16)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    mx = arr.max(axis=2)
    # Generated source sheets are RGB images with a light gray/white checkerboard preview.
    # Treat only near-neutral bright checker pixels as transparent; cream/white fur usually has
    # subtle channel differences and remains foreground.
    background = (np.abs(r - g) <= 12) & (np.abs(r - b) <= 12) & (np.abs(g - b) <= 12) & (mx >= 236)
    alpha = np.where(background, 0, 255).astype("uint8")
    # Keep the visible alpha conservative so checkerboard background pixels do not become halos.
    return Image.fromarray(alpha, mode="L")


def component_records(alpha: Image.Image) -> list[dict[str, object]]:
    raw = np.asarray(alpha) > 0
    # Label on a lightly dilated mask to keep fur/body regions connected, while the
    # visible alpha remains conservative when the frame is finally composited.
    label_mask = np.asarray(alpha.filter(ImageFilter.MaxFilter(7))) > 0
    labels, count = ndi.label(label_mask, structure=np.ones((3, 3), dtype=np.uint8))
    slices = ndi.find_objects(labels)
    records: list[dict[str, object]] = []
    for label_id, region in enumerate(slices, start=1):
        if region is None:
            continue
        y_slice, x_slice = region
        component = labels[region] == label_id
        area = int(component.sum())
        if area < 16:
            continue
        x0, x1 = int(x_slice.start), int(x_slice.stop)
        y0, y1 = int(y_slice.start), int(y_slice.stop)
        records.append(
            {
                "label": label_id,
                "area": area,
                "box": (x0, y0, x1, y1),
                "center": ((x0 + x1) / 2.0, (y0 + y1) / 2.0),
                "width": x1 - x0,
                "height": y1 - y0,
            }
        )
    return records


def select_main_components(records: list[dict[str, object]]) -> list[dict[str, object]]:
    if not records:
        raise SystemExit("No foreground components detected in source sheet")
    max_area = max(int(record["area"]) for record in records)
    main = []
    for record in records:
        area = int(record["area"])
        width = int(record["width"])
        height = int(record["height"])
        # Cat bodies are the largest components. Props such as bowls and paper balls are
        # intentionally excluded here and reattached by proximity to the selected cat body.
        if area >= max(250, int(max_area * 0.20)) and width >= 24 and height >= 24:
            main.append(record)
    if not main:
        raise SystemExit("No main cat components detected in source sheet")
    main.sort(key=lambda record: record["center"][0])
    return main


def labels_for_frame(records: list[dict[str, object]], main: list[dict[str, object]], index: int) -> set[int]:
    if len(main) == FRAME_COUNT:
        main_record = main[index]
    else:
        # Some generated sources visually promise 20 frames but contain fewer distinct
        # connected cat cutouts. Resample the detected action sequence to exactly 20
        # runtime frames instead of keeping partial neighbor slices.
        source_index = round(index * (len(main) - 1) / max(FRAME_COUNT - 1, 1))
        main_record = main[source_index]
    mx0, my0, mx1, my1 = main_record["box"]
    selected = {int(main_record["label"])}
    main_labels = {int(record["label"]) for record in main}
    for record in records:
        label = int(record["label"])
        if label in selected or label in main_labels:
            continue
        area = int(record["area"])
        width = int(record["width"])
        height = int(record["height"])
        cx, cy = record["center"]
        # Keep nearby small props, such as food bowls, water bowls, or paper balls, but
        # reject slim neighbor slivers caused by tight source sprite spacing.
        looks_like_neighbor_sliver = width <= 14 and height >= 35 and area < int(main_record["area"]) * 0.25
        near_main = (mx0 - 70) <= cx <= (mx1 + 85) and (my0 - 55) <= cy <= (my1 + 70)
        small_prop_or_body_part = area >= 16 and not looks_like_neighbor_sliver
        if near_main and small_prop_or_body_part:
            selected.add(label)
    return selected


def bbox_from_mask(mask: np.ndarray) -> tuple[int, int, int, int]:
    ys, xs = np.where(mask)
    if len(xs) == 0:
        raise SystemExit("No selected foreground remains for frame")
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def expand_box(box: tuple[int, int, int, int], image_size: tuple[int, int], padding: int) -> tuple[int, int, int, int]:
    w, h = image_size
    x0, y0, x1, y1 = box
    return max(0, x0 - padding), max(0, y0 - padding), min(w, x1 + padding), min(h, y1 + padding)


def normalize_sprite_sheet(source_path: Path, target_path: Path) -> dict[str, object]:
    source = Image.open(source_path).convert("RGB")
    alpha = foreground_alpha(source)
    rgba = source.convert("RGBA")
    rgba.putalpha(alpha)

    width, height = rgba.size
    raw_alpha = np.asarray(alpha)
    labels, _ = ndi.label(np.asarray(alpha.filter(ImageFilter.MaxFilter(7))) > 0, structure=np.ones((3, 3), dtype=np.uint8))
    records = component_records(alpha)
    main_components = select_main_components(records)

    slots = []
    boxes = []
    frame_masks = []
    for index in range(FRAME_COUNT):
        selected_labels = labels_for_frame(records, main_components, index)
        keep_mask = np.isin(labels, list(selected_labels))
        box = expand_box(bbox_from_mask(keep_mask), rgba.size, padding=10)
        frame_masks.append(keep_mask)
        slots.append((round(index * width / FRAME_COUNT), round((index + 1) * width / FRAME_COUNT)))
        boxes.append(box)

    max_crop_width = max(x1 - x0 for x0, _, x1, _ in boxes)
    max_crop_height = max(y1 - y0 for _, y0, _, y1 in boxes)
    scale = min(MAX_SPRITE_WIDTH / max_crop_width, MAX_SPRITE_HEIGHT / max_crop_height)
    if not math.isfinite(scale) or scale <= 0:
        raise SystemExit(f"Invalid scale for {source_path}")

    output = Image.new("RGBA", (FRAME_WIDTH * FRAME_COUNT, FRAME_HEIGHT), (0, 0, 0, 0))
    frame_reports = []
    baseline = FRAME_HEIGHT - BOTTOM_MARGIN

    for index, box in enumerate(boxes):
        x0, y0, x1, y1 = box
        crop = rgba.crop(box)
        crop_alpha = Image.fromarray((frame_masks[index][y0:y1, x0:x1].astype("uint8") * 255), mode="L")
        crop.putalpha(crop_alpha)
        target_size = (max(1, round(crop.width * scale)), max(1, round(crop.height * scale)))
        resized = crop.resize(target_size, Image.Resampling.LANCZOS)
        frame_left = index * FRAME_WIDTH
        paste_x = frame_left + (FRAME_WIDTH - resized.width) // 2
        paste_y = baseline - resized.height
        if paste_x < frame_left or paste_x + resized.width > frame_left + FRAME_WIDTH or paste_y < 0:
            raise SystemExit(
                f"Frame {index} of {source_path.name} does not fit {FRAME_WIDTH}x{FRAME_HEIGHT}: "
                f"resized={resized.size}, paste=({paste_x},{paste_y})"
            )
        output.alpha_composite(resized, (paste_x, paste_y))
        frame_reports.append(
            {
                "index": index,
                "source_slot": slots[index],
                "source_box": box,
                "render_size": resized.size,
                "frame_rect": [frame_left, 0, FRAME_WIDTH, FRAME_HEIGHT],
                "paste_xy": [paste_x, paste_y],
            }
        )

    target_path.parent.mkdir(parents=True, exist_ok=True)
    output.save(target_path, optimize=False, compress_level=6)
    if output.size != (FRAME_WIDTH * FRAME_COUNT, FRAME_HEIGHT):
        raise SystemExit(f"Unexpected output size for {target_path}: {output.size}")
    return {
        "source": str(source_path),
        "target": str(target_path),
        "source_size": source.size,
        "output_size": output.size,
        "source_slot_count": FRAME_COUNT,
        "frame_width": FRAME_WIDTH,
        "frame_height": FRAME_HEIGHT,
        "scale": round(scale, 4),
        "detected_main_components": len(main_components),
        "max_source_crop_size": [max_crop_width, max_crop_height],
        "frames": frame_reports,
    }


def patch_manifest() -> None:
    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    states = manifest.setdefault("states", {})
    for spec in ACTIONS:
        refs = [f"{spec.target.as_posix()}#{i}" for i in range(FRAME_COUNT)]
        state = {"fps": spec.fps, "loop": spec.loop, "frames": refs}
        if spec.next_state is not None:
            state["nextState"] = spec.next_state
        states[spec.state] = state
    MANIFEST_PATH.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def patch_asset_pose_map() -> None:
    text = ASSET_MAP_PATH.read_text(encoding="utf-8") if ASSET_MAP_PATH.exists() else "# Cat desktop pet asset pose map\n"
    marker = "\n## Additional generated action sheets\n"
    if marker in text:
        text = text.split(marker, 1)[0].rstrip() + "\n"
    rows = [
        "## Additional generated action sheets",
        "",
        "These optional action states are imported from `cat_action_sprites_20f_row.zip` and normalized to the same `320x340` runtime subframe canvas used by the existing sheets. Each output sheet is exactly `6400x340`, so `#0`-`#19` crop to precise `320x340` frames without cutting off the cat, bowl, or paper ball.",
        "",
        "| Runtime state | Sheet | Frames | Loop | Transition behavior |",
        "|---|---|---:|---:|---|",
    ]
    for spec in ACTIONS:
        next_desc = "loops in-place" if spec.loop else f"returns to `{spec.next_state}`"
        rows.append(f"| `{spec.state}` | `{spec.target.as_posix()}` | `#0`-`#19` | `{str(spec.loop).lower()}` | {next_desc} |")
    rows.extend([
        "",
        "### Physical transition notes",
        "",
        "- `eat`, `playPaperBall`, `groom`, `yawn`, and `meow` end in an idle-compatible pose before returning to `idle`.",
        "- `run` and `walk` are continuous gait cycles and therefore loop instead of snapping back to the idle pose.",
        "- `roll` remains a loop because the sheet is a floor/side-lying roll sequence; it is intentionally not configured to jump directly to a standing idle frame.",
        "- The existing `sleep` state is left unchanged: it lowers into the sleeping pose and holds the final sleeping frame instead of looping back through a stand-up transition.",
        "",
    ])
    ASSET_MAP_PATH.write_text(text.rstrip() + "\n" + "\n".join(rows), encoding="utf-8")


def write_action_report(reports: dict[str, object]) -> None:
    lines = [
        "# Imported action sprite sheets",
        "",
        "The Google Drive bundle was normalized into runtime sprite sheets that match the existing `320x340` per-frame crop contract.",
        "",
        "## Output contract",
        "",
        f"- Frame canvas: `{FRAME_WIDTH}x{FRAME_HEIGHT}`",
        f"- Frames per action: `{FRAME_COUNT}`",
        f"- Sheet size per action: `{FRAME_WIDTH * FRAME_COUNT}x{FRAME_HEIGHT}`",
        "- Layout: one horizontal row, addressed by `#0` through `#19`.",
        "- The importer uses a fixed slot width and bottom-aligned paste position per frame, which prevents crop drift in `FrameAnimationPlayer`.",
        "",
        "## Actions",
        "",
        "| State | Source | Output sheet | FPS | Loop | Notes |",
        "|---|---|---|---:|---:|---|",
    ]
    for spec in ACTIONS:
        lines.append(f"| `{spec.state}` | `{spec.source}` | `{spec.target.as_posix()}` | {spec.fps} | `{str(spec.loop).lower()}` | {spec.role} |")
    lines.extend(["", "## Import measurements", ""])
    for state, report in reports.items():
        lines.append(f"### `{state}`")
        lines.append("")
        lines.append("```json")
        lines.append(json.dumps(report, ensure_ascii=False, indent=2))
        lines.append("```")
        lines.append("")
    ACTION_MAP_PATH.write_text("\n".join(lines), encoding="utf-8")


def cleanup_temp_files() -> None:
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
    if not zipfile.is_zipfile(zip_path):
        raise SystemExit("Downloaded file is not a valid ZIP")
    with zipfile.ZipFile(zip_path) as archive:
        archive.testzip()
        archive.extractall(extract_dir)
    bundle_root = find_bundle_root(extract_dir)

    reports: dict[str, object] = {}
    for spec in ACTIONS:
        source_path = bundle_root / spec.source
        if not source_path.is_file():
            raise SystemExit(f"Missing action source image: {source_path}")
        target_path = PET_ROOT / spec.target
        reports[spec.state] = normalize_sprite_sheet(source_path, target_path)

    patch_manifest()
    patch_asset_pose_map()
    write_action_report(reports)
    cleanup_temp_files()

    print("Imported action sprite sheets:")
    for spec in ACTIONS:
        print(f"- {spec.state}: {PET_ROOT / spec.target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
