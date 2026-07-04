#!/usr/bin/env python3
from __future__ import annotations

import json
import statistics
import struct
import sys
import zlib
from pathlib import Path

PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
FRAME_WIDTH = 320
FRAME_HEIGHT = 340
FRAME_COUNT = 20

ACTIONS = {
    "eat": "frames/eat/eat-20f-sheet.png",
    "playPaperBall": "frames/play-paper-ball/play-paper-ball-20f-sheet.png",
    "roll": "frames/roll/roll-20f-sheet.png",
    "groom": "frames/groom/groom-20f-sheet.png",
    "run": "frames/run/run-20f-sheet.png",
    "walk": "frames/walk/walk-20f-sheet.png",
    "yawn": "frames/yawn/yawn-20f-sheet.png",
    "meow": "frames/meow/meow-20f-sheet.png",
}

# These states are mostly stationary front-facing expression loops. A frame whose
# foreground width is many times larger than the median almost certainly contains
# multiple cats accidentally merged into one 320x340 runtime frame.
STABLE_WIDTH_STATES = {"yawn", "meow"}


def fail(message: str) -> None:
    print(message)
    raise SystemExit(1)


def paeth(a: int, b: int, c: int) -> int:
    p = a + b - c
    pa = abs(p - a)
    pb = abs(p - b)
    pc = abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    if pb <= pc:
        return b
    return c


def read_png_alpha(path: Path) -> tuple[int, int, list[list[int]]]:
    data = path.read_bytes()
    if not data.startswith(PNG_SIGNATURE):
        fail(f"{path}: invalid PNG signature")

    offset = len(PNG_SIGNATURE)
    width = height = bit_depth = color_type = None
    idat_parts: list[bytes] = []

    while offset < len(data):
        if offset + 8 > len(data):
            fail(f"{path}: truncated PNG chunk header")
        length = struct.unpack(">I", data[offset : offset + 4])[0]
        chunk_type = data[offset + 4 : offset + 8]
        chunk_data = data[offset + 8 : offset + 8 + length]
        offset += 12 + length

        if chunk_type == b"IHDR":
            width, height, bit_depth, color_type, _compression, _filter, _interlace = struct.unpack(
                ">IIBBBBB", chunk_data
            )
        elif chunk_type == b"IDAT":
            idat_parts.append(chunk_data)
        elif chunk_type == b"IEND":
            break

    if width is None or height is None or bit_depth is None or color_type is None:
        fail(f"{path}: missing IHDR")
    if bit_depth != 8 or color_type != 6:
        fail(f"{path}: expected 8-bit RGBA PNG, got bitDepth={bit_depth}, colorType={color_type}")

    channels = 4
    stride = width * channels
    raw = zlib.decompress(b"".join(idat_parts))
    expected = height * (1 + stride)
    if len(raw) != expected:
        fail(f"{path}: unexpected decompressed size {len(raw)}, expected {expected}")

    rows: list[bytearray] = []
    cursor = 0
    previous = bytearray(stride)
    bpp = channels
    for _row_index in range(height):
        filter_type = raw[cursor]
        cursor += 1
        scan = bytearray(raw[cursor : cursor + stride])
        cursor += stride

        if filter_type == 0:
            recon = scan
        elif filter_type == 1:
            recon = bytearray(stride)
            for i, value in enumerate(scan):
                left = recon[i - bpp] if i >= bpp else 0
                recon[i] = (value + left) & 0xFF
        elif filter_type == 2:
            recon = bytearray(stride)
            for i, value in enumerate(scan):
                recon[i] = (value + previous[i]) & 0xFF
        elif filter_type == 3:
            recon = bytearray(stride)
            for i, value in enumerate(scan):
                left = recon[i - bpp] if i >= bpp else 0
                up = previous[i]
                recon[i] = (value + ((left + up) // 2)) & 0xFF
        elif filter_type == 4:
            recon = bytearray(stride)
            for i, value in enumerate(scan):
                left = recon[i - bpp] if i >= bpp else 0
                up = previous[i]
                upper_left = previous[i - bpp] if i >= bpp else 0
                recon[i] = (value + paeth(left, up, upper_left)) & 0xFF
        else:
            fail(f"{path}: unsupported PNG filter {filter_type}")

        rows.append(recon)
        previous = recon

    alpha_rows: list[list[int]] = []
    for row in rows:
        alpha_rows.append([row[x * 4 + 3] for x in range(width)])
    return width, height, alpha_rows


def frame_bounds(alpha_rows: list[list[int]], frame_index: int) -> tuple[int, int, int, int] | None:
    x_start = frame_index * FRAME_WIDTH
    x_end = x_start + FRAME_WIDTH
    min_x = FRAME_WIDTH
    max_x = -1
    min_y = FRAME_HEIGHT
    max_y = -1
    for y, row in enumerate(alpha_rows):
        for local_x, alpha in enumerate(row[x_start:x_end]):
            if alpha:
                min_x = min(min_x, local_x)
                max_x = max(max_x, local_x)
                min_y = min(min_y, y)
                max_y = max(max_y, y)
    if max_x < 0:
        return None
    return min_x, min_y, max_x + 1, max_y + 1


def validate_action(manifest: dict, pet_root: Path, state_name: str, sheet_path: str) -> None:
    state = manifest.get("states", {}).get(state_name)
    if not isinstance(state, dict):
        fail(f"missing action state: {state_name}")

    frames = state.get("frames")
    if not isinstance(frames, list) or len(frames) != FRAME_COUNT:
        fail(f"state {state_name}: expected {FRAME_COUNT} frames, got {len(frames) if isinstance(frames, list) else 'invalid'}")

    expected_frames = [f"{sheet_path}#{index}" for index in range(FRAME_COUNT)]
    if frames != expected_frames:
        fail(f"state {state_name}: frame list must be exactly {expected_frames}")

    png_path = pet_root / sheet_path
    if not png_path.is_file():
        fail(f"state {state_name}: missing sheet {png_path}")

    width, height, alpha_rows = read_png_alpha(png_path)
    expected_width = FRAME_WIDTH * FRAME_COUNT
    if (width, height) != (expected_width, FRAME_HEIGHT):
        fail(f"{png_path}: expected {expected_width}x{FRAME_HEIGHT}, got {width}x{height}")

    widths: list[int] = []
    heights: list[int] = []
    for index in range(FRAME_COUNT):
        bounds = frame_bounds(alpha_rows, index)
        if bounds is None:
            fail(f"{png_path}#{index}: empty alpha frame")
        left, top, right, bottom = bounds
        frame_width = right - left
        frame_height = bottom - top
        widths.append(frame_width)
        heights.append(frame_height)

        min_margin = min(left, top, FRAME_WIDTH - right, FRAME_HEIGHT - bottom)
        if min_margin < 6:
            fail(
                f"{png_path}#{index}: foreground too close to crop edge; "
                f"bounds={bounds}, minMargin={min_margin}"
            )

    median_width = statistics.median(widths)
    if state_name in STABLE_WIDTH_STATES:
        for index, frame_width in enumerate(widths):
            if frame_width > median_width * 1.45:
                fail(
                    f"{png_path}#{index}: foreground width {frame_width} is too large for stable "
                    f"{state_name} animation median {median_width}; likely multiple source frames merged"
                )

    print(
        f"action sheet ok: {state_name} {width}x{height}, "
        f"frame bbox width {min(widths)}-{max(widths)}, height {min(heights)}-{max(heights)}"
    )


def main() -> int:
    if len(sys.argv) != 2:
        fail("usage: validate-action-sprite-sheets.py path/to/pet.json")
    manifest_path = Path(sys.argv[1])
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    pet_root = manifest_path.parent

    window = manifest.get("window", {})
    if window.get("width") != FRAME_WIDTH or window.get("height") != FRAME_HEIGHT:
        fail(f"action sheet validator expects window {FRAME_WIDTH}x{FRAME_HEIGHT}, got {window}")

    for state_name, sheet_path in ACTIONS.items():
        validate_action(manifest, pet_root, state_name, sheet_path)

    print("action sprite sheets ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
