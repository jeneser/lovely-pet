# macOS compatibility validation report

Supported versions under review: macOS 26 Tahoe, macOS 15 Sequoia, macOS 14 Sonoma, macOS 13 Ventura, macOS 12 Monterey

| Check | Result | Detail |
|---|---:|---|
| SwiftPM minimum deployment target is macOS 12 | PASS | Package.swift must keep platforms: [.macOS(.v12)] so one binary supports macOS 12+. |
| Package.swift names every supported macOS major version | PASS | covers 26, 15, 14, 13, 12 |
| SwiftUI onChange uses macOS 12-compatible perform overload | PASS | Use .onChange(of:perform:) rather than the newer two-argument closure form. |
| onContinuousHover is guarded for macOS 13+ with a macOS 12 fallback | PASS | macOS 12 must not evaluate onContinuousHover; it should retain onHover-only behavior. |
| NSApp.activate API is selected by runtime availability | PASS | macOS 14+ should use activate(); macOS 12/13 should use activate(ignoringOtherApps:). |
| Compatibility document covers all target versions and validation modes | PASS | documented coverage is complete |
| No extra unguarded newer API call sites were introduced | PASS | onContinuousHover mentions=2; NSApp.activate() mentions=1. Expected one guarded call plus one documentation/comment mention for onContinuousHover, and one guarded NSApp.activate() call. |
