# Building BetterTTY

> **BetterTTY 1.0.2:** This document contains earlier build/release checkpoints and may show historical 1.0.0 examples. For the current 1.0.2 version, verified commands and release gates, start with [Build 1.0.2](BUILD_1.0.2.md) and [Release Status 1.0.2](RELEASE_STATUS_1.0.2.md). Do not copy historical version strings into new packages.


BetterTTY is a Qt 6 / C++ / CMake / libssh project.

## Linux dependencies

Debian/Ubuntu/Linux Mint style systems:

```bash
sudo apt update
sudo apt install -y \
  build-essential \
  cmake \
  ninja-build \
  git \
  pkg-config \
  gdb \
  qtcreator \
  qt6-base-dev \
  qt6-base-dev-tools \
  qt6-tools-dev \
  qt6-tools-dev-tools \
  qt6-webengine-dev \
  libssh-dev
```

If CMake reports missing Qt WebEngine:

```bash
sudo apt install qt6-webengine-dev
```

If CMake reports missing libssh:

```bash
sudo apt install libssh-dev
```

## Configure and build

```bash
cmake -S . -B build -G Ninja
cmake --build build
./build/bettertty
```

Clean rebuild:

```bash
cmake --build build --clean-first
```

## Qt Creator

Open `CMakeLists.txt` in Qt Creator, configure a Qt 6 kit, then build and run.

## Current runtime requirements

- Qt Widgets
- Qt WebEngineWidgets
- Qt WebChannel
- libssh

xterm.js assets are bundled as Qt resources under:

```text
resources/xterm/
```

No CDN should be required for terminal rendering.

## Current tested platform

Linux remains the primary development platform. Windows native Debug/Release build validation, standalone deploy-folder validation, known-host portability, and Windows libssh KEX compatibility have been validated on real Windows 10/11 machines. macOS still needs dedicated validation.

## Version identity

The About dialog reads version strings from `CMakeLists.txt`:

```cmake
set(BETTERTTY_VERSION_STRING "1.0.0")
set(BETTERTTY_CODENAME_STRING "Andromeda")
set(BETTERTTY_MILESTONE_STRING "Initial BetterTTY release")
```

Every generated checkpoint should update the version string.


---

## Windows native build

A native Windows build has been validated during the Andromeda line using MSVC, Ninja, Qt 6.11.1 MSVC 2022 64-bit, Qt WebEngine/WebChannel/Positioning, vcpkg `libssh`, and vcpkg `pkgconf`.

See the dedicated guide:

- [Windows Build Guide](WINDOWS_BUILD.md)

Short version:

```cmd
cmake -S . -B build-win -G Ninja ^
  -DCMAKE_BUILD_TYPE=Debug ^
  -DCMAKE_PREFIX_PATH=C:\Qt\6.11.1\msvc2022_64 ^
  -DCMAKE_TOOLCHAIN_FILE=C:\dev\vcpkg\scripts\buildsystems\vcpkg.cmake ^
  -DPKG_CONFIG_EXECUTABLE=C:\dev\vcpkg\installed\x64-windows\tools\pkgconf\pkgconf.exe

cmake --build build-win
```

Release build testing should use `build-win-release` and `-DCMAKE_BUILD_TYPE=Release`.


## Icon resources

BetterTTY icon assets live under:

```text
resources/icons/
resources/windows/
resources/macos/
```

The Qt app icon is embedded as a Qt resource and loaded from:

```text
:/icons/bettertty.png
```

Windows executable icon integration uses:

```text
resources/windows/bettertty.rc.in (template; CMake generates build-win-release/generated/bettertty.rc)
resources/windows/bettertty.ico
```

macOS bundle icon prep uses:

```text
resources/macos/bettertty.icns
resources/macos/bettertty.iconset/
```

Linux packaging can later install the PNG size variants from `resources/icons/` into the appropriate hicolor icon theme directories.


---

## Windows deployment

After a Release build succeeds, see [Windows Deployment Guide](WINDOWS_DEPLOYMENT.md) for the first `windeployqt`-based standalone deployment test and helper script:

```text
scripts/windows-deploy-release.bat
```


## Linux Release/package helper

For the current Linux package workflow:

```bash
./scripts/linux-build-release.sh
./scripts/linux-package-deb.sh
```

See `docs/LINUX_PACKAGING.md`.


## Debian package tutorial

For the full `.deb` packaging/install/remove workflow, see [Debian Package Tutorial](DEBIAN_PACKAGE_TUTORIAL.md).


## macOS Intel build/deploy helper

For the first macOS Intel `.app` / `.dmg` workflow:

```bash
./scripts/macos-build-release.sh
./scripts/macos-deploy-release.sh
```

Default Qt path:

```text
~/Qt/6.11.1/macos
```

See [macOS Build Guide](MACOS_BUILD.md) and [macOS Deployment Guide](MACOS_DEPLOYMENT.md).
