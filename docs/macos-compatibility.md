# macOS compatibility coverage

Lovely Pet targets **macOS 12 Monterey and newer**. Compatibility coverage is tracked explicitly for the following major versions:

| Major version | Name | Coverage status | Validation mode |
|---:|---|---|---|
| macOS 26 | Tahoe | Required | Hosted CI compile/package validation on `macos-26`; source-level compatibility audit; runtime smoke checklist |
| macOS 15 | Sequoia | Required | Hosted CI compile/package validation on `macos-15`; source-level compatibility audit; runtime smoke checklist |
| macOS 14 | Sonoma | Required | Hosted CI compile/package validation on `macos-14`; source-level compatibility audit; runtime smoke checklist |
| macOS 13 | Ventura | Required | Source-level compatibility audit; manual or self-hosted runtime smoke validation |
| macOS 12 | Monterey | Required | Source-level compatibility audit; manual or self-hosted runtime smoke validation |

GitHub-hosted macOS runners currently cover `macos-14`, `macos-15`, and `macos-26`. macOS 12 and macOS 13 are still part of the support contract, but they require manual hardware/VM validation or self-hosted runners because they are not available as standard GitHub-hosted runner labels.

For the manual `macOS legacy runtime validation` workflow, register self-hosted runners with these labels:

| Target | Required self-hosted labels |
|---|---|
| macOS 12 Monterey | `self-hosted`, `macOS`, `macos-12` |
| macOS 13 Ventura | `self-hosted`, `macOS`, `macos-13` |

## Validation layers

### 1. Hosted CI compile/package validation

The main CI workflow builds and packages the Swift template on every GitHub-hosted macOS major version available for this coverage set:

```text
macos-26
macos-15
macos-14
```

Each hosted run records:

```bash
sw_vers
xcodebuild -version
swift --version
make validate
make compat
make build
make package
```

This confirms the app can be validated, source-audited, compiled, and packaged against the SDK/toolchain on macOS 26, macOS 15, and macOS 14 runners.

### 2. Source-level compatibility audit

`make compat` runs `pipeline/scripts/validate-macos-compatibility.py`. The audit fails if any of the following compatibility guarantees are broken:

- `Package.swift` must declare `platforms: [.macOS(.v12)]`.
- The support comment must mention macOS 26, macOS 15, macOS 14, macOS 13, and macOS 12.
- `onContinuousHover` must remain behind `if #available(macOS 13, *)`, with a macOS 12 no-op fallback.
- `NSApp.activate()` must remain behind `if #available(macOS 14, *)`, with `activate(ignoringOtherApps:)` retained for macOS 12 and 13.
- `onChange` must use the macOS 12-compatible `.onChange(of:perform:)` overload.
- This document must continue to list all target major versions and validation modes.

This gives macOS 12 and macOS 13 explicit source-level coverage even when the current CI provider cannot boot those releases.

### 3. Manual runtime smoke validation

Run the following checklist on real hardware, a VM, or self-hosted runner for each supported major version: macOS 26 Tahoe, macOS 15 Sequoia, macOS 14 Sonoma, macOS 13 Ventura, and macOS 12 Monterey.

```bash
sw_vers
make validate
make compat
make build
make package
open "templates/macos-desktop-pet/dist/Lovely Pet.app"
```

After launch, verify:

- the pet window appears without a crash;
- the status bar item appears as a single pet-control icon;
- **Settings** opens the settings window;
- **Quit** exits the app;
- hover changes the pet state;
- tap/double-tap triggers the tap and heart-burst feedback;
- long press/drag interaction does not crash;
- scale changes from Settings resize the pet image and window together;
- Settings -> Reset Stored Data clears saved scale and saved window position;
- idle sleep transition still works.

Record the result in this table when runtime validation is performed:

| Version | Host build | CPU | Commands passed | Runtime smoke result | Notes |
|---|---|---|---|---|---|
| macOS 26 Tahoe | _pending_ | _pending_ | _pending_ | _pending_ | Hosted CI compile/package coverage exists. |
| macOS 15 Sequoia | _pending_ | _pending_ | _pending_ | _pending_ | Hosted CI compile/package coverage exists. |
| macOS 14 Sonoma | _pending_ | _pending_ | _pending_ | _pending_ | Hosted CI compile/package coverage exists. |
| macOS 13 Ventura | _pending_ | _pending_ | _pending_ | _pending_ | Requires manual/self-hosted validation. |
| macOS 12 Monterey | _pending_ | _pending_ | _pending_ | _pending_ | Requires manual/self-hosted validation. |

## API compatibility contract

| API or behavior | macOS 12 | macOS 13 | macOS 14 | macOS 15 | macOS 26 |
|---|---|---|---|---|---|
| SwiftPM deployment target | `.macOS(.v12)` | `.macOS(.v12)` | `.macOS(.v12)` | `.macOS(.v12)` | `.macOS(.v12)` |
| `onChange(of:perform:)` | Used | Used | Used | Used | Used |
| `onContinuousHover` | No-op fallback | Available path | Available path | Available path | Available path |
| `NSApp.activate()` | Uses `activate(ignoringOtherApps:)` fallback | Uses `activate(ignoringOtherApps:)` fallback | Uses `activate()` | Uses `activate()` | Uses `activate()` |
| `onHover` | Available | Available | Available | Available | Available |

Do not remove an availability guard unless the minimum deployment target is raised and this document is updated in the same change.
