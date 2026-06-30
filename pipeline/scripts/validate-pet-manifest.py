#!/usr/bin/env python3
"""Validate a Lovely Pet manifest.

This script intentionally uses only Python standard library checks so it can run
in CI without extra dependencies. It validates the MVP subset of the schema and
also verifies that referenced frame files exist relative to the manifest file.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any


def fail(message: str) -> None:
    print(f"manifest validation failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def require(condition: bool, message: str) -> None:
    if not condition:
        fail(message)


def load_manifest(path: Path) -> dict[str, Any]:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        fail(f"cannot read JSON: {exc}")
    require(isinstance(data, dict), "root must be an object")
    return data


def main() -> None:
    if len(sys.argv) != 2:
        print("usage: validate-pet-manifest.py <pet.json>", file=sys.stderr)
        raise SystemExit(2)

    manifest_path = Path(sys.argv[1]).resolve()
    data = load_manifest(manifest_path)

    for key in ["id", "name", "scale", "anchor", "defaultState", "states"]:
        require(key in data, f"missing required field: {key}")

    require(isinstance(data["id"], str) and data["id"], "id must be a non-empty string")
    require(isinstance(data["name"], str) and data["name"], "name must be a non-empty string")
    require(isinstance(data["scale"], (int, float)), "scale must be numeric")
    require(data["anchor"] in {"bottom-right", "bottom-left", "center", "custom"}, "invalid anchor")
    require(isinstance(data["states"], dict) and data["states"], "states must be a non-empty object")
    require(data["defaultState"] in data["states"], "defaultState must exist in states")

    base = manifest_path.parent
    for state_name, state in data["states"].items():
        require(isinstance(state, dict), f"state {state_name} must be an object")
        require(isinstance(state.get("fps"), int), f"state {state_name}.fps must be an integer")
        require(1 <= state["fps"] <= 60, f"state {state_name}.fps must be 1..60")
        require(isinstance(state.get("loop"), bool), f"state {state_name}.loop must be boolean")
        frames = state.get("frames")
        require(isinstance(frames, list) and frames, f"state {state_name}.frames must be a non-empty list")
        for frame in frames:
            require(isinstance(frame, str) and frame, f"state {state_name} has invalid frame path")
            require((base / frame).exists(), f"missing frame referenced by {state_name}: {frame}")

    print(f"manifest ok: {manifest_path}")


if __name__ == "__main__":
    main()
