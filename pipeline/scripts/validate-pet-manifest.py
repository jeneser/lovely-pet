#!/usr/bin/env python3
import json
import sys
from pathlib import Path


def fail(message: str) -> None:
    print(message)
    raise SystemExit(1)


def split_frame_reference(frame: str) -> tuple[str, str | None]:
    path, separator, fragment = frame.partition("#")
    if not path.strip():
        fail("frame path before # must be non-empty")
    if separator and (not fragment.isdigit() or int(fragment) < 0):
        fail(f"sprite frame index must be a non-negative integer: {frame}")
    return path, fragment if separator else None


def validate_relative_png_frame(pet_root: Path, state_name: str, frame: object) -> None:
    if not isinstance(frame, str) or not frame.strip():
        fail(f"state {state_name}: every frame must be a non-empty PNG path")

    frame_base, _ = split_frame_reference(frame)
    frame_path = Path(frame_base)
    if frame_path.is_absolute() or ".." in frame_path.parts:
        fail(f"state {state_name}: frame path must stay inside the pet folder: {frame}")

    if frame_path.suffix.lower() != ".png":
        fail(f"state {state_name}: frame must be a PNG file: {frame}")

    if not (pet_root / frame_path).is_file():
        fail(f"state {state_name}: PNG frame does not exist: {frame}")


def main() -> int:
    path = Path(sys.argv[1])
    data = json.loads(path.read_text(encoding="utf-8"))
    pet_root = path.parent

    required = ["id", "name", "renderer", "window", "defaultState", "behavior", "states"]
    missing = [key for key in required if key not in data]
    if missing:
        fail("missing fields: " + ", ".join(missing))

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
            validate_relative_png_frame(pet_root, state_name, frame)

    print("manifest ok: " + str(path))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
