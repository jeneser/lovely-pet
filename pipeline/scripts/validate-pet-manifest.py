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
print("manifest ok: " + str(path))
