# BetterTTY 1.0.0 build and test notes

Codename: **Andromeda**

## Build identity checks

Before platform testing, confirm:

```text
Product: BetterTTY
Version: 1.0.0
Codename: Andromeda
Config: BetterTTY.json
Organization: DD-LAB
Website: https://bettertty.dev
```

Expected binaries:

```text
Linux:   bettertty
Windows: BetterTTY.exe
macOS:   BetterTTY.app
```

## Linux

```bash
./scripts/linux-build-release.sh
./build-linux-release/bettertty
```

Optional Debian package:

```bash
./scripts/linux-package-deb.sh
```

## Windows

Build with the supported Qt/MSVC/vcpkg environment, then run:

```bat
scripts\windows-deploy-release.bat
scripts\windows-package-portable.bat
```

Confirm the executable is `BetterTTY.exe` and Windows file metadata reports BetterTTY 1.0.0 and DD-LAB.

## macOS

```bash
./scripts/macos-build-release.sh
./scripts/macos-deploy-release.sh
```

Confirm the bundle is `BetterTTY.app` and the package uses the BetterTTY icon.

## Smoke test

Run `docs/TESTCASE_1.0.md` after each platform build.
