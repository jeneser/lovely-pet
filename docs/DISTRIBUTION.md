# Distribution

This document covers neutral distribution notes for the macOS app bundle.

## Local package

```bash
make package
```

Output:

```text
templates/macos-desktop-pet/dist/Lovely Pet.app
templates/macos-desktop-pet/dist/Lovely-Pet-macOS.zip
```

## GitHub Actions artifact

The CI workflow uploads `Lovely-Pet-macOS.zip` as an artifact named `Lovely-Pet-macOS`.

## Release workflow

The release workflow can be run manually from GitHub Actions. It packages the app and attaches the zip to a prerelease.

## macOS security notes

The default build uses ad-hoc signing for quick local testing. For broad external distribution, use a Developer ID certificate, hardened runtime, and Apple notarization.

## Asset privacy

Keep private source photos out of git unless they are intentionally public sample assets.
