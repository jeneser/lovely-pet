#!/usr/bin/env python3
import json
import sys
from pathlib import Path

PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


def fail(message: str) -> None:
    print(message)
    raise SystemExit(1)


def split_frame_reference(frame: str) -> tuple[str, int | None]:
    path, separator, fragment = frame.partition("#")
    if not path.strip():
        fail("frame path before # must be non-empty")
    if separator:
        if not fragment.isdigit() or int(fragment) < 0:
            fail(f"sprite frame index must be a non-negative integer: {frame}")
        return path, int(fragment)
    return path, None


def png_size(path: Path) -> tuple[int, int]:
    with path.open("rb") as file:
        if file.read(8) != PNG_SIGNATURE:
            fail(f"PNG file has an invalid signature: {path}")
        file.read(4)  # IHDR chunk length
        if file.read(4) != b"IHDR":
            fail(f"PNG file is missing an IHDR chunk: {path}")
        width = int.from_bytes(file.read(4), "big")
        height = int.from_bytes(file.read(4), "big")
        return width, height


def validate_png_dimensions(path: Path, frame: str, sprite_index: int | None, frame_width: int, frame_height: int) -> None:
    width, height = png_size(path)

    if sprite_index is None:
        if width != frame_width or height != frame_height:
            fail(
                f"frame {frame}: PNG dimensions must match pet window "
                f"{frame_width}x{frame_height}, got {width}x{height}"
            )
        return

    if height != frame_height:
        fail(
            f"sprite sheet {frame}: height must match pet window "
            f"{frame_height}, got {height}"
        )
    if width % frame_width != 0:
        fail(
            f"sprite sheet {frame}: width {width} must be a multiple of frame width {frame_width}"
        )

    frame_count = width // frame_width
    if sprite_index >= frame_count:
        fail(
            f"sprite sheet {frame}: index #{sprite_index} is outside "
            f"{frame_count} available {frame_width}x{frame_height} frames"
        )


def validate_relative_png_frame(pet_root: Path, state_name: str, frame: object, frame_width: int, frame_height: int) -> None:
    if not isinstance(frame, str) or not frame.strip():
        fail(f"state {state_name}: every frame must be a non-empty PNG path")

    frame_base, sprite_index = split_frame_reference(frame)
    frame_path = Path(frame_base)
    if frame_path.is_absolute() or ".." in frame_path.parts:
        fail(f"state {state_name}: frame path must stay inside the pet folder: {frame}")

    if frame_path.suffix.lower() != ".png":
        fail(f"state {state_name}: frame must be a PNG file: {frame}")

    resolved_path = pet_root / frame_path
    if not resolved_path.is_file():
        fail(f"state {state_name}: PNG frame does not exist: {frame}")

    validate_png_dimensions(resolved_path, frame, sprite_index, frame_width, frame_height)


def validate_window(data: dict) -> tuple[int, int]:
    window = data.get("window")
    if not isinstance(window, dict):
        fail("window must be an object")

    width = window.get("width")
    height = window.get("height")
    if not isinstance(width, int) or width <= 0:
        fail("window.width must be a positive integer")
    if not isinstance(height, int) or height <= 0:
        fail("window.height must be a positive integer")
    return width, height


def main() -> int:
    path = Path(sys.argv[1])
    data = json.loads(path.read_text(encoding="utf-8"))
    pet_root = path.parent

    required = ["id", "name", "renderer", "window", "defaultState", "behavior", "states"]
    missing = [key for key in required if key not in data]
    if missing:
        fail("missing fields: " + ", ".join(missing))

    frame_width, frame_height = validate_window(data)

    renderer = data.get("renderer")
    if not isinstance(renderer, dict) or renderer.get("type") != "imageAssets":
        fail("renderer.type must be imageAssets so the pet is rendered from PNG image frames")

    states = data.get("states")
    if not isinstance(states, dict) or not states:
        fail("states must be a non-empty object")

    if data["defaultState"] not in states:
        fail("defaultState must exist in states")

    for state_name, state in states.items():
        if not isinstance(state, dict):
            fail(f"state {state_name}: state config must be an object")

        fps = state.get("fps")
        if not isinstance(fps, int) or fps <= 0:
            fail(f"state {state_name}: fps must be a positive integer")

        if not isinstance(state.get("loop"), bool):
            fail(f"state {state_name}: loop must be a boolean")

        next_state = state.get("nextState")
        if next_state is not None and next_state not in states:
            fail(f"state {state_name}: nextState must reference another declared state")

        frames = state.get("frames")
        if not isinstance(frames, list) or not frames:
            fail(f"state {state_name}: frames must be a non-empty list of PNG paths")

        for frame in frames:
            validate_relative_png_frame(pet_root, state_name, frame, frame_width, frame_height)

    print("manifest ok: " + str(path))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
