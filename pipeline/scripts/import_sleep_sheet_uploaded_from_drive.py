#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from urllib.request import Request, urlopen

import cv2
import numpy as np
from PIL import Image, ImageFilter

DRIVE_FILE_ID = "1nva9fuCR4qvX4VUVFA5uSjeFRic3G9RO"
TARGET_PATH = Path("templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/sleep/sleep-sheet.png")
MANIFEST_PATH = Path("templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json")
TEMP_WORKFLOW = Path(".github/workflows/import-sleep-sheet-uploaded-from-drive.yml")
TEMP_SCRIPT = Path("pipeline/scripts/import_sleep_sheet_uploaded_from_drive.py")
FRAME_WIDTH = 320
FRAME_HEIGHT = 340
FRAME_COUNT = 7
BOTTOM_MARGIN = 18
PNG_MAGIC = b"\x89PNG\r\n\x1a\n"


def download_drive_png() -> Path:
    url = f"https://drive.usercontent.google.com/download?id={DRIVE_FILE_ID}&export=download&confirm=t"
    request = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    data = urlopen(request, timeout=120).read()
    if not data.startswith(PNG_MAGIC):
        preview = data[:120]
        raise SystemExit(
            "Drive response is not a PNG. Make the uploaded Drive file readable by anyone with the link, "
            f"then rerun this workflow. Response prefix: {preview!r}"
        )
    source = Path("/tmp/uploaded-sleep-sheet.png")
    source.write_bytes(data)
    print(f"downloaded {len(data)} bytes from Google Drive file {DRIVE_FILE_ID}")
    return source


def foreground_components(rgb: np.ndarray) -> list[tuple[int, int, int, int, int]]:
    hsv = cv2.cvtColor(rgb, cv2.COLOR_RGB2HSV)
    saturation = hsv[:, :, 1]
    value = hsv[:, :, 2]
    seed = ((saturation > 18) | (value < 235)).astype(np.uint8)
    seed = cv2.morphologyEx(seed, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
    seed = cv2.dilate(seed, np.ones((15, 15), np.uint8), iterations=1)
    count, labels, stats, _ = cv2.connectedComponentsWithStats(seed, 8)
    components: list[tuple[int, int, int, int, int]] = []
    for index in range(1, count):
        x, y, width, height, area = stats[index]
        if area > 1000:
            components.append((int(x), int(y), int(width), int(height), int(area)))
    components.sort(key=lambda item: item[0])
    if len(components) != FRAME_COUNT:
        raise SystemExit(f"Expected {FRAME_COUNT} sleep poses, found {len(components)} components: {components}")
    return components


def extract_pose(rgb: np.ndarray, component: tuple[int, int, int, int, int]) -> Image.Image:
    image_height, image_width = rgb.shape[:2]
    x, y, width, height, _ = component
    padding = 28
    x0 = max(0, x - padding)
    y0 = max(0, y - padding)
    x1 = min(image_width, x + width + padding)
    y1 = min(image_height, y + height + padding)
    crop_rgb = rgb[y0:y1, x0:x1].copy()
    crop_height, crop_width = crop_rgb.shape[:2]

    hsv = cv2.cvtColor(crop_rgb, cv2.COLOR_RGB2HSV)
    saturation = hsv[:, :, 1]
    value = hsv[:, :, 2]
    definite_foreground = ((saturation > 22) | (value < 230)).astype(np.uint8)

    mask = np.full((crop_height, crop_width), cv2.GC_PR_BGD, dtype=np.uint8)
    mask[:6, :] = cv2.GC_BGD
    mask[-6:, :] = cv2.GC_BGD
    mask[:, :6] = cv2.GC_BGD
    mask[:, -6:] = cv2.GC_BGD

    probable_foreground = cv2.dilate(definite_foreground, np.ones((31, 31), np.uint8), iterations=1)
    mask[probable_foreground > 0] = cv2.GC_PR_FGD
    mask[definite_foreground > 0] = cv2.GC_FGD

    background_model = np.zeros((1, 65), np.float64)
    foreground_model = np.zeros((1, 65), np.float64)
    cv2.grabCut(crop_rgb, mask, None, background_model, foreground_model, 8, cv2.GC_INIT_WITH_MASK)

    alpha_mask = np.where((mask == cv2.GC_FGD) | (mask == cv2.GC_PR_FGD), 255, 0).astype(np.uint8)
    connected_count, connected_labels, connected_stats, _ = cv2.connectedComponentsWithStats(alpha_mask, 8)
    if connected_count > 1:
        largest = 1 + int(np.argmax(connected_stats[1:, cv2.CC_STAT_AREA]))
        alpha_mask = np.where(connected_labels == largest, 255, 0).astype(np.uint8)

    alpha_mask = cv2.morphologyEx(alpha_mask, cv2.MORPH_CLOSE, np.ones((3, 3), np.uint8), iterations=1)
    flood_fill = alpha_mask.copy()
    flood_mask = np.zeros((crop_height + 2, crop_width + 2), np.uint8)
    cv2.floodFill(flood_fill, flood_mask, (0, 0), 255)
    holes = cv2.bitwise_not(flood_fill)
    alpha_mask = cv2.bitwise_or(alpha_mask, holes)

    alpha = Image.fromarray(alpha_mask).filter(ImageFilter.GaussianBlur(0.6))
    pose = Image.fromarray(crop_rgb).convert("RGBA")
    pose.putalpha(alpha)
    return pose


def normalize_uploaded_sheet(source_path: Path) -> Image.Image:
    source = Image.open(source_path).convert("RGBA")
    if source.size == (FRAME_WIDTH * FRAME_COUNT, FRAME_HEIGHT):
        print("source already matches runtime frame grid; using it directly")
        return source

    rgb = np.array(source)[:, :, :3]
    components = foreground_components(rgb)
    poses = [extract_pose(rgb, component) for component in components]

    sheet = Image.new("RGBA", (FRAME_WIDTH * FRAME_COUNT, FRAME_HEIGHT), (0, 0, 0, 0))
    for index, pose in enumerate(poses):
        alpha_bbox = pose.getchannel("A").getbbox()
        if alpha_bbox is None:
            raise SystemExit(f"Pose {index} became empty after background removal")
        trimmed = pose.crop(alpha_bbox)
        pose_width, pose_height = trimmed.size
        scale = min(1.0, 310 / pose_width, 300 / pose_height)
        if scale < 1.0:
            trimmed = trimmed.resize((round(pose_width * scale), round(pose_height * scale)), Image.Resampling.LANCZOS)
            pose_width, pose_height = trimmed.size
        offset_x = (FRAME_WIDTH - pose_width) // 2
        offset_y = FRAME_HEIGHT - pose_height - BOTTOM_MARGIN
        if offset_x < 0 or offset_y < 0:
            raise SystemExit(f"Pose {index} does not fit in a {FRAME_WIDTH}x{FRAME_HEIGHT} frame")
        sheet.alpha_composite(trimmed, (index * FRAME_WIDTH + offset_x, offset_y))
        print(f"pose {index}: placed at frame-local ({offset_x}, {offset_y}) size {pose_width}x{pose_height}")
    return sheet


def referenced_sleep_indices() -> list[int]:
    manifest = json.loads(MANIFEST_PATH.read_text())
    window = manifest.get("window", {})
    if window.get("width") != FRAME_WIDTH or window.get("height") != FRAME_HEIGHT:
        raise SystemExit(f"Manifest window must stay {FRAME_WIDTH}x{FRAME_HEIGHT}; got {window}")

    frames = manifest.get("states", {}).get("sleep", {}).get("frames", [])
    indices: list[int] = []
    for frame in frames:
        path, marker, index_text = frame.partition("#")
        if path != "frames/sleep/sleep-sheet.png" or marker != "#":
            raise SystemExit(f"Unexpected sleep frame reference: {frame}")
        indices.append(int(index_text))
    if not indices:
        raise SystemExit("Sleep state references no frames")
    if max(indices) >= FRAME_COUNT:
        raise SystemExit(f"Sleep frame index outside normalized sheet: {indices}")
    return indices


def validate_runtime_crops(sheet: Image.Image) -> None:
    indices = sorted(set(referenced_sleep_indices()))
    expected_size = (FRAME_WIDTH * FRAME_COUNT, FRAME_HEIGHT)
    if sheet.size != expected_size:
        raise SystemExit(f"Sleep sheet must be exactly {expected_size}; got {sheet.size}")

    for index in indices:
        crop = sheet.crop((index * FRAME_WIDTH, 0, (index + 1) * FRAME_WIDTH, FRAME_HEIGHT))
        alpha = np.array(crop.getchannel("A"))
        ys, xs = np.where(alpha > 0)
        if len(xs) == 0:
            raise SystemExit(f"Frame {index} is empty")
        bbox = (int(xs.min()), int(ys.min()), int(xs.max() + 1), int(ys.max() + 1))
        margins = (bbox[0], bbox[1], FRAME_WIDTH - bbox[2], FRAME_HEIGHT - bbox[3])
        if min(margins) < 3:
            raise SystemExit(f"Frame {index} is too close to crop edge; bbox={bbox}, margins={margins}")
        print(f"frame {index}: bbox={bbox}, margins={margins}")


def main() -> None:
    source = download_drive_png()
    sheet = normalize_uploaded_sheet(source)
    validate_runtime_crops(sheet)

    TARGET_PATH.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(TARGET_PATH, format="PNG", compress_level=0)
    digest = hashlib.sha256(TARGET_PATH.read_bytes()).hexdigest()
    print(f"wrote {TARGET_PATH} ({TARGET_PATH.stat().st_size} bytes, sha256={digest})")

    for temporary_path in (TEMP_WORKFLOW, TEMP_SCRIPT):
        temporary_path.unlink(missing_ok=True)
        print(f"removed temporary import file: {temporary_path}")


if __name__ == "__main__":
    main()
