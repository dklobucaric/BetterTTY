# BetterTTY 1.0.2 — Native builds and packages

This is a maintainer checklist, **not proof of release readiness**. Use the real Qt/libssh toolchain for each target OS. Every package must display version `1.0.2`. See [release status](RELEASE_STATUS_1.0.2.md).

## Windows 11 — MSVC + Qt6 + vcpkg (CMD without admin privileges)

```bat
call "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
cd /d C:\dev\BetterTTY
cmake -S . -B build-win-release -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_PREFIX_PATH=C:\Qt\6.11.1\msvc2022_64 ^
  -DCMAKE_TOOLCHAIN_FILE=C:\dev\vcpkg\scripts\buildsystems\vcpkg.cmake ^
  -DPKG_CONFIG_EXECUTABLE=C:\dev\vcpkg\installed\x64-windows\tools\pkgconf\pkgconf.exe
cmake --build build-win-release --parallel 4
set "PATH=C:\Qt\6.11.1\msvc2022_64\bin;C:\dev\vcpkg\installed\x64-windows\bin;%PATH%"
build-win-release\BetterTTY.exe
```

Then, from same development shell:

```bat
scripts\windows-deploy-release.bat
powershell -ExecutionPolicy Bypass -File scripts\windows-package-portable.ps1
```

**Test the portable folder on a separate clean Windows system.** Merely running inside the development shell can hide missing DLL dependencies. Check EXE Properties → Details for the version.

## Debian/Ubuntu Linux — native source and `.deb`

Requirements: C++20 compiler, Qt 6 Core/Widgets/WebEngineWidgets/WebChannel development components, `libssh` development package, pkg-config, CMake, Ninja, dpkg tools, plus X11/Wayland-capable desktop environment. Package names and minimum versions depend on the distro; Debian 12 Qt 6 packages can differ from the Windows/macOS reference Qt version.

```bash
cd ~/BetterTTY
chmod +x scripts/linux-build-release.sh scripts/linux-package-deb.sh
./scripts/linux-build-release.sh
./build-linux-release/bettertty
./scripts/linux-package-deb.sh
dpkg-deb -I dist/deb/bettertty_1.0.2_$(dpkg --print-architecture).deb
```

Then install using a **disposable/test machine or VM**:

```bash
sudo apt install ./dist/deb/bettertty_1.0.2_$(dpkg --print-architecture).deb
```

Do not make claims about all Linux distributions from testing one distribution. Validate SFTP and Qt WebEngine in a regular desktop user session (avoid running a Chromium-based GUI as root).

## macOS — native `.app` and `.dmg`

Install Xcode command-line tools, Homebrew, CMake, Ninja, pkg-config, libssh and the Qt6 WebEngineWidgets/WebChannel component set. The default helper uses `QT_DIR=$HOME/Qt/6.11.1/macos`; adjust if your Qt installation differs.

```bash
cd ~/BetterTTY
chmod +x scripts/macos-build-release.sh scripts/macos-deploy-release.sh
./scripts/macos-build-release.sh
open build-macos-release/BetterTTY.app
./scripts/macos-deploy-release.sh
```

The helper now defaults `MACOS_ARCH` to the current `uname -m`. For another architecture, specify `MACOS_ARCH=x86_64` or `MACOS_ARCH=arm64` only with an appropriate Qt/libssh/toolchain for that architecture. The script can produce a DMG but **does not imply Apple Developer ID notarization**; on another Mac the Gatekeeper policy may prevent normal launch. Review otool dependencies and code-sign state before distribution.

## Final publication workflow

1. Commit reviewed source and documentation on a release candidate branch; run basic lint/version checks.
2. Test builds on each OS, collect actual build logs and `docs/QA_MATRIX_1.0.2.md` results.
3. Capture and redact screenshots following `docs/SCREENSHOTS.md`.
4. Generate SHA-256 sums of packages, test clean install/use/remove.
5. Merge to `main`, tag `v1.0.2`, attach release notes and **verified** artifacts.
6. Only then update `bettertty.dev` public landing page (next phase, not this source change).
