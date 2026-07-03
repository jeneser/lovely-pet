#!/usr/bin/env python3
"""Temporary importer for replacing the sleep sprite sheet from a public Drive image.

This follows the project binary-import workflow pattern: download the public Drive
PNG, normalize it into the manifest's 7x 320x340 sleep sheet layout, update the
sleep frame order so the final sleeping frame repeats, and remove temporary files
so the PR only keeps production assets.
"""
from __future__ import annotations

import json
import os
import urllib.request
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageChops, ImageDraw, ImageFilter
from scipy import ndimage as ndi

DRIVE_FILE_ID = "1IDWuVhTXlfPau3zrSDUj8WNc_7DQkV2O"
DOWNLOAD_URL = f"https://drive.usercontent.google.com/download?id={DRIVE_FILE_ID}&export=download&confirm=t"
ROOT = Path(__file__).resolve().parents[2]
PET_DIR = ROOT / "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default"
SLEEP_SHEET = PET_DIR / "frames/sleep/sleep-sheet.png"
PET_JSON = PET_DIR / "pet.json"
WORKFLOW = ROOT / ".github/workflows/import-sleep-sheet-from-drive.yml"
THIS_SCRIPT = Path(__file__).resolve()
SOURCE = ROOT / "build/sleep-sheet-generated-source.png"
PREVIEW = ROOT / "build/sleep-sheet-generated-preview.png"
CELL_W = 320
CELL_H = 340
FRAMES = 7


def download_source() -> None:
    SOURCE.parent.mkdir(parents=True, exist_ok=True)
    req = urllib.request.Request(DOWNLOAD_URL, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=60) as response:
        data = response.read()
    if len(data) < 100_000:
        raise RuntimeError(f"Downloaded file is unexpectedly small: {len(data)} bytes")
    SOURCE.write_bytes(data)
    print(f"downloaded {len(data)} bytes from Drive to {SOURCE}")


def make_mask(seg: Image.Image) -> np.ndarray:
    arr = np.array(seg.convert("RGB")).astype(np.int16)
    mx = arr.max(axis=2)
    mn = arr.min(axis=2)
    chroma = mx - mn
    mean = arr.mean(axis=2)

    # The generated image has a white/light-gray checkerboard preview background.
    # Keep colored/dark/edge pixels as foreground, then connect/fill the cat body.
    mask = (mean < 239) | (chroma > 7)
    gray = np.array(seg.convert("L")).astype(np.uint8)
    edges = cv2.Canny(gray, 18, 55) > 0
    mask |= ndi.binary_dilation(edges, iterations=1) & (mean < 253)
    mask = ndi.binary_opening(mask, iterations=1)
    mask = ndi.binary_closing(mask, iterations=3)

    labels, count = ndi.label(mask)
    if count:
        sizes = np.bincount(labels.ravel())
        sizes[0] = 0
        keep = np.zeros_like(mask, dtype=bool)
        for idx, size in enumerate(sizes):
            if idx and size > 1000:
                keep |= labels == idx
        mask = keep

    mask = ndi.binary_closing(mask, iterations=2)
    mask = ndi.binary_fill_holes(mask)
    mask = ndi.binary_dilation(mask, iterations=1)
    return mask


def normalize_sheet() -> None:
    source = Image.open(SOURCE).convert("RGB")
    width, height = source.size
    if width < 1000 or height < 300:
        raise RuntimeError(f"Source image dimensions look wrong: {source.size}")

    sheet = Image.new("RGBA", (CELL_W * FRAMES, CELL_H), (0, 0, 0, 0))
    bboxes: list[tuple[int, tuple[int, int, int, int] | None]] = []

    for frame_index in range(FRAMES):
        left = round(frame_index * width / FRAMES)
        right = round((frame_index + 1) * width / FRAMES)
        seg = source.crop((left, 0, right, height))
        mask = make_mask(seg)
        alpha = Image.fromarray((mask.astype(np.uint8) * 255), "L").filter(ImageFilter.GaussianBlur(0.8))
        alpha_arr = np.array(alpha)
        alpha_arr[alpha_arr < 22] = 0
        alpha_arr[alpha_arr > 235] = 255
        alpha = Image.fromarray(alpha_arr.astype(np.uint8), "L")

        rgba = seg.convert("RGBA")
        rgba.putalpha(alpha)
        bbox = rgba.getbbox()
        bboxes.append((frame_index, bbox))
        if bbox is None:
            raise RuntimeError(f"Frame {frame_index} is empty after background removal")

        crop = rgba.crop(bbox)
        scale = min(306 / crop.width, 285 / crop.height, 1.0)
        if scale < 1.0:
            crop = crop.resize((round(crop.width * scale), round(crop.height * scale)), Image.Resampling.LANCZOS)

        x = frame_index * CELL_W + (CELL_W - crop.width) // 2
        y = 314 - crop.height
        sheet.alpha_composite(crop, (x, y))

    SLEEP_SHEET.parent.mkdir(parents=True, exist_ok=True)
    # PNG compression is lossless; use level 0 here to avoid optimizer-style changes.
    sheet.save(SLEEP_SHEET, format="PNG", compress_level=0)
    print(f"wrote {SLEEP_SHEET} size={sheet.size} bytes={SLEEP_SHEET.stat().st_size}")
    print("frame bboxes:", bboxes)

    # Generate a local preview artifact only for logs/debug; it is not committed.
    preview = Image.new("RGBA", (CELL_W * FRAMES, CELL_H + 28), (255, 255, 255, 255))
    preview.alpha_composite(sheet, (0, 0))
    draw = ImageDraw.Draw(preview)
    for frame_index in range(FRAMES):
        x = frame_index * CELL_W
        draw.line((x, 0, x, CELL_H), fill=(180, 180, 180, 255), width=1)
        draw.text((x + 8, CELL_H + 5), f"#{frame_index}", fill=(0, 0, 0, 255))
    preview.save(PREVIEW, format="PNG", compress_level=0)


def update_pet_json() -> None:
    data = json.loads(PET_JSON.read_text(encoding="utf-8"))
    data["window"] = {"width": CELL_W, "height": CELL_H}
    data["states"]["sleep"]["fps"] = 2
    data["states"]["sleep"]["loop"] = True
    data["states"]["sleep"]["frames"] = [
        "frames/sleep/sleep-sheet.png#0",
        "frames/sleep/sleep-sheet.png#1",
        "frames/sleep/sleep-sheet.png#2",
        "frames/sleep/sleep-sheet.png#3",
        "frames/sleep/sleep-sheet.png#4",
        "frames/sleep/sleep-sheet.png#5",
        "frames/sleep/sleep-sheet.png#6",
        "frames/sleep/sleep-sheet.png#6",
    ]
    PET_JSON.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"updated {PET_JSON}")


def validate_output() -> None:
    image = Image.open(SLEEP_SHEET).convert("RGBA")
    if image.size != (CELL_W * FRAMES, CELL_H):
        raise RuntimeError(f"Unexpected output size: {image.size}")
    for frame_index in range(FRAMES):
        crop = image.crop((frame_index * CELL_W, 0, (frame_index + 1) * CELL_W, CELL_H))
        if crop.getbbox() is None:
            raise RuntimeError(f"Output frame {frame_index} is empty")
    print("validated output sleep sheet")


def cleanup_temp_files() -> None:
    for path in (WORKFLOW, THIS_SCRIPT):
        if path.exists():
            path.unlink()
            print(f"removed temporary file {path}")


def main() -> None:
    download_source()
    normalize_sheet()
    update_pet_json()
    validate_output()
    cleanup_temp_files()


if __name__ == "__main__":
    main()
