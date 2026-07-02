#!/usr/bin/env python3
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
data = json.loads(path.read_text())
required = ["id", "name", "renderer", "window", "defaultState", "behavior", "states"]
missing = [key for key in required if key not in data]
if missing:
    print("missing fields: " + ", ".join(missing))
    raise SystemExit(1)
if data["defaultState"] not in data["states"]:
    print("defaultState must exist in states")
    raise SystemExit(1)
if data["renderer"].get("type") != "imageAssets":
    print("renderer.type must be imageAssets")
    raise SystemExit(1)
if data["window"].get("width", 0) <= 0 or data["window"].get("height", 0) <= 0:
    print("window width/height must be positive")
    raise SystemExit(1)

pet_root = path.parent
for state_name, state in data["states"].items():
    for key in ("fps", "loop", "frames"):
        if key not in state:
            print(f"state {state_name} missing {key}")
            raise SystemExit(1)
    if int(state["fps"]) <= 0:
        print(f"state {state_name} fps must be positive")
        raise SystemExit(1)
    frames = list(state.get("frames") or []) + list(state.get("exitFrames") or [])
    if not frames:
        print(f"state {state_name} must include at least one frame")
        raise SystemExit(1)
    for frame in frames:
        frame_path = pet_root / frame
        if not frame_path.is_file():
            print(f"missing frame for {state_name}: {frame}")
            raise SystemExit(1)
        if frame_path.stat().st_size <= 0:
            print(f"empty frame for {state_name}: {frame}")
            raise SystemExit(1)
print("manifest ok: " + str(path))
