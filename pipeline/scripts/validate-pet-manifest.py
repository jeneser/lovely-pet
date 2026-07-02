#!/usr/bin/env python3
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
data = json.loads(path.read_text())

required = [
    "id",
    "name",
    "renderer",
    "window",
    "behavior",
    "scale",
    "anchor",
    "defaultState",
    "states",
]
missing = [key for key in required if key not in data]
if missing:
    print("missing fields: " + ", ".join(missing))
    raise SystemExit(1)

states = data["states"]
if not isinstance(states, dict) or not states:
    print("states must be a non-empty object")
    raise SystemExit(1)

if data["defaultState"] not in states:
    print("defaultState must exist in states")
    raise SystemExit(1)

renderer = data["renderer"]
if not isinstance(renderer, dict) or renderer.get("type") != "imageAssets":
    print("renderer.type must be imageAssets")
    raise SystemExit(1)

window = data["window"]
if not isinstance(window, dict) or window.get("width", 0) <= 0 or window.get("height", 0) <= 0:
    print("window width/height must be positive")
    raise SystemExit(1)

try:
    scale = float(data["scale"])
except (TypeError, ValueError):
    print("scale must be numeric")
    raise SystemExit(1)
if scale <= 0:
    print("scale must be positive")
    raise SystemExit(1)

if not isinstance(data["anchor"], str) or not data["anchor"].strip():
    print("anchor must be a non-empty string")
    raise SystemExit(1)

behavior = data["behavior"]
if not isinstance(behavior, dict):
    print("behavior must be an object")
    raise SystemExit(1)
for behavior_key in ("hoverState", "tapState", "sleepState"):
    target_state = behavior.get(behavior_key)
    if target_state is not None and target_state not in states:
        print(f"behavior.{behavior_key} references missing state: {target_state}")
        raise SystemExit(1)

pet_root = path.parent
for state_name, state in states.items():
    if not isinstance(state, dict):
        print(f"state {state_name} must be an object")
        raise SystemExit(1)

    for key in ("fps", "loop", "frames"):
        if key not in state:
            print(f"state {state_name} missing {key}")
            raise SystemExit(1)

    try:
        fps = int(state["fps"])
    except (TypeError, ValueError):
        print(f"state {state_name} fps must be an integer")
        raise SystemExit(1)
    if fps <= 0:
        print(f"state {state_name} fps must be positive")
        raise SystemExit(1)

    if not isinstance(state["loop"], bool):
        print(f"state {state_name} loop must be boolean")
        raise SystemExit(1)

    state_frames = state.get("frames")
    if not isinstance(state_frames, list) or not state_frames:
        print(f"state {state_name} must include at least one frame")
        raise SystemExit(1)

    exit_frames = state.get("exitFrames") or []
    if not isinstance(exit_frames, list):
        print(f"state {state_name} exitFrames must be an array when present")
        raise SystemExit(1)

    next_state = state.get("nextState")
    if next_state is not None and next_state not in states:
        print(f"state {state_name} nextState references missing state: {next_state}")
        raise SystemExit(1)

    for frame in state_frames + exit_frames:
        if not isinstance(frame, str) or not frame.strip():
            print(f"state {state_name} includes an invalid frame path")
            raise SystemExit(1)
        frame_path = pet_root / frame
        if not frame_path.is_file():
            print(f"missing frame for {state_name}: {frame}")
            raise SystemExit(1)
        if frame_path.stat().st_size <= 0:
            print(f"empty frame for {state_name}: {frame}")
            raise SystemExit(1)

print("manifest ok: " + str(path))
