# Distribution

This document covers distribution notes for the macOS app bundle.

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

The release workflow can be run manually from GitHub Actions or triggered by changing `.github/release-version.txt`. It packages the app and attaches the zip to a prerelease.

## GitHub Packages

The release workflow also publishes the zip as an OCI artifact in GitHub Packages using GitHub Container Registry:

```text
ghcr.io/<owner>/lovely-pet-macos:<tag>
ghcr.io/<owner>/lovely-pet-macos:latest
```

The primary user-facing download remains the GitHub Release asset. The package upload is useful for automated retrieval and version tracking.

## macOS security notes

The default build uses ad-hoc signing for quick local testing. For broad external distribution, use a Developer ID certificate, hardened runtime, and Apple notarization.

## Asset privacy

Keep private source photos out of git unless they are intentionally public sample assets.
