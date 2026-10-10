# BetterTTY macOS Deployment Guide

> **BetterTTY 1.0.2:** This document contains earlier build/release checkpoints and may show historical 1.0.0 examples. For the current 1.0.2 version, verified commands and release gates, start with [Build 1.0.2](BUILD_1.0.2.md) and [Release Status 1.0.2](RELEASE_STATUS_1.0.2.md). Do not copy historical version strings into new packages.


**Checkpoint:** `1.0.0` — Andromeda
**Phase:** macOS DMG/dependency and artifact version polish

This guide documents the first deployable macOS package path for BetterTTY.

The goal of this checkpoint is practical tester distribution:

```text
BetterTTY.app
BetterTTY-1.0.0-macOS-x86_64.dmg
```

The generated DMG contains:

```text
BetterTTY.app
Applications -> /Applications
README_FIRST.txt
```

The user opens the DMG and drags `BetterTTY.app` to the `Applications` shortcut. The small `README_FIRST.txt` file gives testers unsigned-app/Gatekeeper launch guidance without requiring them to find the full documentation first.

---

## 1. Build first

```bash
cd ~/BetterTTY
./scripts/macos-build-release.sh
```

Expected build output:

```text
build-macos-release/BetterTTY.app
```

---

## 2. Create deployable app and DMG

```bash
./scripts/macos-deploy-release.sh
```

Default settings:

```text
QT_DIR=$HOME/Qt/6.11.1/macos
BUILD_DIR=build-macos-release
DIST_DIR=dist/macos
MACOS_ARCH=x86_64
BETTERTTY_MACOS_VERSION=<optional override; defaults to BETTERTTY_VERSION_STRING from CMakeLists.txt>
CODESIGN_ADHOC=1
```

Since `1.0.0`, the default artifact version is parsed from `BETTERTTY_VERSION_STRING` in `CMakeLists.txt`. The `BETTERTTY_MACOS_VERSION=...` environment variable remains available only as an explicit override.


Expected output:

```text
dist/macos/BetterTTY.app
dist/macos/BetterTTY-1.0.0-macOS-x86_64.dmg
dist/macos/BetterTTY-1.0.0-macOS-x86_64-otool-report.txt
```

Optional strict dependency audit:

```bash
STRICT_DEP_AUDIT=1 ./scripts/macos-deploy-release.sh
```

With `STRICT_DEP_AUDIT=1`, deployment fails if the generated audit still contains local build paths such as `/Users/...`, `/usr/local/...`, or `/opt/homebrew/...`. Without strict mode, the script prints warnings and still creates the DMG so the developer can inspect the result.

---

## 3. What the deployment script does

`scripts/macos-deploy-release.sh` performs these steps:

```text
1. Builds the app if build-macos-release/BetterTTY.app is missing.
2. Copies BetterTTY.app to dist/macos/BetterTTY.app.
3. Runs macdeployqt to bundle Qt frameworks/plugins/WebEngine resources.
4. Scans the app binary with otool.
5. Copies Homebrew dylibs from /usr/local or /opt/homebrew into Contents/Frameworks.
6. Rewrites dylib references with install_name_tool.
7. Applies an ad-hoc signature for local testing when possible.
8. Writes an `otool` dependency audit report beside the DMG.
9. Warns if local build/Homebrew paths remain after bundling.
10. Creates a DMG staging folder with BetterTTY.app, an Applications symlink, and `README_FIRST.txt`.
11. Creates a compressed DMG with hdiutil.
```

Homebrew dylib bundling is needed because `macdeployqt` handles Qt runtime files but does not automatically bundle every non-Qt dependency such as Homebrew `libssh` / OpenSSL.

---

## 4. Local test

Open the deployed app:

```bash
open dist/macos/BetterTTY.app
```

Open the DMG:

```bash
open dist/macos/BetterTTY-1.0.0-macOS-x86_64.dmg
```

Then drag `BetterTTY.app` to `Applications` and launch it from there.

---

## 5. Inspect dependencies

The deploy script now writes a dependency audit report automatically:

```bash
cat dist/macos/BetterTTY-1.0.0-macOS-x86_64-otool-report.txt
```

Manual spot check:

```bash
otool -L dist/macos/BetterTTY.app/Contents/MacOS/BetterTTY
```

A good deployable app should not depend on personal build paths such as:

```text
/Users/user/Qt/...
/usr/local/Cellar/libssh/...
/usr/local/opt/openssl@3/...
/opt/homebrew/Cellar/libssh/...
```

Qt framework references may use bundle-relative paths, and Homebrew libraries should be copied into:

```text
BetterTTY.app/Contents/Frameworks/
```

Useful checks:

```bash
grep -E '/Users/|/usr/local/|/opt/homebrew/' dist/macos/BetterTTY-1.0.0-macOS-x86_64-otool-report.txt || echo "Dependency audit looks clean"
STRICT_DEP_AUDIT=1 ./scripts/macos-deploy-release.sh
```

If a tester Mac reports `Library not loaded`, run `otool -L`, inspect the generated report, and look for the missing path.

---

## 6. Gatekeeper and signing notes

This first DMG is intentionally **unsigned and not notarized**.

Expected tester behavior:

```text
Right-click BetterTTY.app -> Open
```

or, for internal testing only:

```bash
xattr -dr com.apple.quarantine /Applications/BetterTTY.app
open /Applications/BetterTTY.app
```

Future release work should add:

```text
Developer ID signing
hardened runtime where needed
notarization with notarytool
stapling
Homebrew Cask packaging
```

---

## 7. macOS version notes

The first validated build machine is:

```text
macOS 15.7.5
Intel x86_64
Qt 6.11.1
```

Recommended initial support statement:

```text
macOS support is experimental.
Initial package: Intel x86_64 DMG.
Target: modern macOS / Qt 6.11-compatible systems.
Apple Silicon may run the Intel app through Rosetta 2.
Native arm64 and universal builds are planned.
macOS 12.x is not the primary target for this Qt 6.11.1 build.
```

Older macOS compatibility should be handled as a separate legacy-build experiment, not by weakening the main packaging path.

---

## 8. Tester checklist

On a clean tester Mac:

```text
[ ] DMG opens
[ ] DMG contains BetterTTY.app, Applications shortcut, and README_FIRST.txt
[ ] BetterTTY.app can be dragged to Applications
[ ] App opens via right-click -> Open if Gatekeeper blocks first launch
[ ] About shows `1.0.0`
[ ] Settings opens
[ ] Config path is created
[ ] Saved session can be created/imported
[ ] Password SSH login works
[ ] Private-key SSH login works
[ ] xterm.js terminal opens
[ ] whoami works
[ ] htop/top works
[ ] Exit safety still prompts when connected tabs are open
```
