#!/usr/bin/env python3
"""Validate macOS compatibility coverage for the Swift desktop pet template.

This is intentionally a source-level compatibility gate, not a substitute for
runtime testing. It verifies that the repository declares the intended minimum
macOS version, documents every supported major version, and keeps newer AppKit
and SwiftUI APIs behind the availability guards required for macOS 12+.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

SUPPORTED_MAJOR_VERSIONS: tuple[int, ...] = (26, 15, 14, 13, 12)
SUPPORTED_VERSION_NAMES: dict[int, str] = {
    26: "Tahoe",
    15: "Sequoia",
    14: "Sonoma",
    13: "Ventura",
    12: "Monterey",
}

REPO_ROOT = Path(__file__).resolve().parents[2]
PACKAGE_FILE = REPO_ROOT / "templates/macos-desktop-pet/Package.swift"
PET_VIEW_FILE = REPO_ROOT / "templates/macos-desktop-pet/Sources/LovelyPetApp/PetView.swift"
APP_FILE = REPO_ROOT / "templates/macos-desktop-pet/Sources/LovelyPetApp/LovelyPetApplication.swift"
COMPAT_DOC = REPO_ROOT / "docs/macos-compatibility.md"


@dataclass(frozen=True)
class CheckResult:
    name: str
    passed: bool
    detail: str


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError:
        return ""


def has_pattern(text: str, pattern: str) -> bool:
    return re.search(pattern, text, re.MULTILINE | re.DOTALL) is not None


def check_package_minimum(package: str) -> CheckResult:
    passed = ".macOS(.v12)" in package
    return CheckResult(
        "SwiftPM minimum deployment target is macOS 12",
        passed,
        "Package.swift must keep platforms: [.macOS(.v12)] so one binary supports macOS 12+.",
    )


def check_package_comment(package: str) -> CheckResult:
    missing = [f"macOS {version}" for version in SUPPORTED_MAJOR_VERSIONS if f"macOS {version}" not in package]
    return CheckResult(
        "Package.swift names every supported macOS major version",
        not missing,
        "missing: " + ", ".join(missing) if missing else "covers 26, 15, 14, 13, 12",
    )


def check_on_change_compat(pet_view: str) -> CheckResult:
    uses_perform = ".onChange(of: interaction.asleep, perform:" in pet_view
    two_arg_comment_removed = "two-argument" not in pet_view
    return CheckResult(
        "SwiftUI onChange uses macOS 12-compatible perform overload",
        uses_perform and two_arg_comment_removed,
        "Use .onChange(of:perform:) rather than the newer two-argument closure form.",
    )


def check_continuous_hover_guard(pet_view: str) -> CheckResult:
    guarded = has_pattern(
        pet_view,
        r"if\s+#available\(macOS\s+13,\s*\*\)\s*\{(?:(?!else\s*\{).)*\.onContinuousHover\s*\{",
    )
    fallback = has_pattern(
        pet_view,
        r"else\s*\{\s*(?://[^\n]*\n\s*)?content\s*\}",
    )
    return CheckResult(
        "onContinuousHover is guarded for macOS 13+ with a macOS 12 fallback",
        guarded and fallback,
        "macOS 12 must not evaluate onContinuousHover; it should retain onHover-only behavior.",
    )


def check_activate_guard(app: str) -> CheckResult:
    guarded_new_api = has_pattern(
        app,
        r"if\s+#available\(macOS\s+14,\s*\*\)\s*\{\s*NSApp\.activate\(\)\s*\}\s*else\s*\{\s*NSApp\.activate\(ignoringOtherApps:\s*true\)",
    )
    return CheckResult(
        "NSApp.activate API is selected by runtime availability",
        guarded_new_api,
        "macOS 14+ should use activate(); macOS 12/13 should use activate(ignoringOtherApps:).",
    )


def check_compat_doc(doc: str) -> CheckResult:
    missing_versions = [f"macOS {version}" for version in SUPPORTED_MAJOR_VERSIONS if f"macOS {version}" not in doc]
    required_phrases = [
        "Hosted CI compile/package validation",
        "Source-level compatibility audit",
        "Manual runtime smoke validation",
        "macOS 12 Monterey",
        "macOS 13 Ventura",
    ]
    missing_phrases = [phrase for phrase in required_phrases if phrase not in doc]
    passed = not missing_versions and not missing_phrases
    detail_parts: list[str] = []
    if missing_versions:
        detail_parts.append("missing versions: " + ", ".join(missing_versions))
    if missing_phrases:
        detail_parts.append("missing validation sections: " + ", ".join(missing_phrases))
    return CheckResult(
        "Compatibility document covers all target versions and validation modes",
        passed,
        "; ".join(detail_parts) if detail_parts else "documented coverage is complete",
    )


def check_no_unguarded_apis(pet_view: str, app: str) -> CheckResult:
    # This check is deliberately narrow: these are the APIs that caused the
    # deployment target to be raised previously or have different availability
    # behavior across the supported macOS range.
    hover_mentions = pet_view.count("onContinuousHover")
    activate_new_mentions = len(re.findall(r"NSApp\.activate\(\)", app))
    passed = hover_mentions == 2 and activate_new_mentions == 1
    detail = (
        f"onContinuousHover mentions={hover_mentions}; NSApp.activate() mentions={activate_new_mentions}. "
        "Expected one guarded call plus one documentation/comment mention for onContinuousHover, and one guarded NSApp.activate() call."
    )
    return CheckResult("No extra unguarded newer API call sites were introduced", passed, detail)


def iter_results() -> Iterable[CheckResult]:
    package = read_text(PACKAGE_FILE)
    pet_view = read_text(PET_VIEW_FILE)
    app = read_text(APP_FILE)
    doc = read_text(COMPAT_DOC)

    yield check_package_minimum(package)
    yield check_package_comment(package)
    yield check_on_change_compat(pet_view)
    yield check_continuous_hover_guard(pet_view)
    yield check_activate_guard(app)
    yield check_compat_doc(doc)
    yield check_no_unguarded_apis(pet_view, app)


def render_report(results: list[CheckResult]) -> str:
    lines = [
        "# macOS compatibility validation report",
        "",
        "Supported versions under review: "
        + ", ".join(f"macOS {version} {SUPPORTED_VERSION_NAMES[version]}" for version in SUPPORTED_MAJOR_VERSIONS),
        "",
        "| Check | Result | Detail |",
        "|---|---:|---|",
    ]
    for result in results:
        status = "PASS" if result.passed else "FAIL"
        safe_detail = result.detail.replace("|", "\\|")
        lines.append(f"| {result.name} | {status} | {safe_detail} |")
    lines.append("")
    return "\n".join(lines)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--report",
        type=Path,
        help="Optional path to write a Markdown compatibility validation report.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    results = list(iter_results())
    report = render_report(results)
    print(report)

    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(report, encoding="utf-8")

    failed = [result for result in results if not result.passed]
    if failed:
        print("\nCompatibility validation failed:", file=sys.stderr)
        for result in failed:
            print(f"- {result.name}: {result.detail}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
