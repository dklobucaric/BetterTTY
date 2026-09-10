# BetterTTY Debian Package Tutorial

**Checkpoint:** `1.0.0` — Andromeda
**Goal:** build, package, install, test, and remove the first BetterTTY `.deb` package.

This tutorial is the practical copy/paste path for creating a local Debian package from the BetterTTY source tree.

The package produced by this checkpoint is a **system-runtime package**. It installs the BetterTTY binary, desktop file, icons, README, license, Markdown documentation, and screenshots. It expects Qt/libssh runtime libraries from the Linux distribution instead of bundling them inside the package.

## 0. Start from the project root

```bash
cd ~/BetterTTY
git status
```

The working tree should be clean before packaging a checkpoint.

## 1. Install build and packaging dependencies

On Debian, Ubuntu, Linux Mint, or LMDE-style systems:

```bash
sudo apt update
sudo apt install -y \
  build-essential \
  cmake \
  ninja-build \
  git \
  pkg-config \
  qt6-base-dev \
  qt6-base-dev-tools \
  qt6-tools-dev \
  qt6-tools-dev-tools \
  qt6-webengine-dev \
  libssh-dev \
  dpkg-dev \
  fakeroot \
  desktop-file-utils \
  hicolor-icon-theme
```

Package names can vary slightly between distributions. If a package name is different on your distro, install the matching Qt 6 / Qt WebEngine / libssh development package.

## 2. Build the Linux Release binary

```bash
./scripts/linux-build-release.sh
```

Expected binary:

```text
build-linux-release/bettertty
```

Optional local smoke test before packaging:

```bash
./build-linux-release/bettertty
```

Check the About dialog and confirm it shows:

```text
Version: `1.0.0`
Codename: Andromeda
```

## 3. Build the `.deb`

```bash
./scripts/linux-package-deb.sh
```

Expected output:

```text
dist/deb/bettertty_1.0.0_amd64.deb
```

The script stages the package with `cmake --install`, writes Debian control metadata, copies maintainer hooks, calculates installed size, and builds the package with `dpkg-deb`.

## 4. Inspect the package

```bash
dpkg-deb -I dist/deb/bettertty_1.0.0_amd64.deb
```

List the package contents:

```bash
dpkg-deb -c dist/deb/bettertty_1.0.0_amd64.deb | less
```

Useful paths to verify:

```text
/usr/bin/bettertty
/usr/share/applications/bettertty.desktop
/usr/share/icons/hicolor/*/apps/bettertty.png
/usr/share/doc/bettertty/README.md
/usr/share/doc/bettertty/docs/LINUX_PACKAGING.md
/usr/share/doc/bettertty/docs/DEBIAN_PACKAGE_TUTORIAL.md
/usr/share/doc/bettertty/docs/screenshots/*.png
```

## 5. Install locally

```bash
sudo apt install ./dist/deb/bettertty_1.0.0_amd64.deb
```

Run from terminal:

```bash
bettertty
```

The desktop launcher should also appear in the application menu after the desktop database/icon cache refresh.

## 6. Smoke-test the installed app

Minimum test pass:

```text
[ ] BetterTTY starts from terminal with `bettertty`
[ ] app icon appears
[ ] About shows `1.0.0`
[ ] existing user config is preserved
[ ] Settings opens and shows the config path
[ ] saved session list loads
[ ] password SSH login works
[ ] private-key SSH login works
[ ] xterm.js terminal opens
[ ] `whoami` works
[ ] `htop` works
[ ] exit safety works when an SSH session is still connected
```

## 7. Remove the package

```bash
sudo apt remove bettertty
```

This removes the installed application files, but it does **not** remove your user config.

User config normally remains under the Qt standard config path, for example:

```text
~/.config/DD-LAB/BetterTTY/BetterTTY.json
```

Remove that manually only if you intentionally want to delete saved sessions/secrets/backups.

## 8. Build a different package version manually

The package script accepts an override:

```bash
BETTERTTY_DEB_VERSION=1.0.0 ./scripts/linux-package-deb.sh
```

It also accepts a manual dependency override if `dpkg-shlibdeps` cannot produce suitable dependencies for your distribution:

```bash
BETTERTTY_DEB_DEPENDS="libc6, libstdc++6, libgcc-s1, libssh-4, libqt6core6, libqt6gui6, libqt6widgets6, libqt6webchannel6, libqt6webenginewidgets6" \
  ./scripts/linux-package-deb.sh
```

## 9. What this package does not do yet

This first `.deb` does not yet provide:

- AppImage
- Snap/Flatpak
- bundled Qt runtime
- signed package/repository
- auto-update mechanism
- official PPA

Those are later packaging checkpoints.
