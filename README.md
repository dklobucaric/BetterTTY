# BetterTTY

**A better way to SSH.**  
*Your servers. One dock.*

BetterTTY is a clean, cross-platform SSH and SFTP client built with Qt 6, C++, CMake, libssh, and a bundled xterm.js terminal renderer.

- **Version:** 1.0.0
- **Codename:** Andromeda
- **Website:** https://bettertty.dev
- **License:** MIT
- **Copyright:** © 2026 Dalibor Klobučarić
- **Developer / publisher:** DD-LAB

## What BetterTTY does

BetterTTY keeps server access, terminal sessions, and file transfers in one desktop application:

- saved SSH sessions with grouping
- password and private-key authentication
- known-host verification before authentication
- multi-key known-host entries per `host:port`
- xterm.js terminal tabs with bundled offline assets
- SSH PTY resize synchronization
- native paste routing and multiline paste handling
- Ctrl+C remote interrupt behavior
- two-panel local/remote SFTP file manager
- queue-first upload and download workflow
- recursive folder scan-to-queue transfers
- sequential transfer queue with retry support
- overwrite / skip / overwrite-all / skip-all decisions
- queued local and remote delete with safety confirmations
- live SSH terminal and SFTP transfer traffic counters
- config import, export, backup, restore, and corrupt-config recovery
- optional diagnostic logging, disabled by default
- Linux, Windows, and macOS packaging helpers

## Configuration

BetterTTY stores its application configuration in:

```text
BetterTTY.json
```

Qt's platform application-data paths are used with the application identity **DD-LAB / BetterTTY**. The exact active path is visible in the Settings and About dialogs.

The current config schema stores sessions, settings, known-host data, metadata, and optional `plain-v1` secrets in one JSON file.

> **Security:** `plain-v1` secret values are human-readable. Keep `BetterTTY.json` private, never commit a real config to Git, and use this storage mode only on trusted machines. See `docs/SECURITY_NOTES.md`.

## Quick start

1. Build and launch BetterTTY.
2. Create a saved session from **Session → New Session**.
3. Double-click a saved session to open an SSH terminal.
4. Right-click a saved session and choose **Open file manager** for SFTP.

For detailed setup and usage, see `docs/GETTING_STARTED.md` and `docs/USER_GUIDE.md`.

## Build

The core build requires:

- CMake 3.24+
- C++20 compiler
- Qt 6: Core, Widgets, WebEngineWidgets, WebChannel
- pkg-config
- libssh

Typical Linux release build:

```bash
./scripts/linux-build-release.sh
```

The resulting Linux executable is:

```text
build-linux-release/bettertty
```

Platform-specific guides:

- `docs/BUILDING.md`
- `docs/WINDOWS_BUILD.md`
- `docs/MACOS_BUILD.md`
- `docs/LINUX_PACKAGING.md`

## Release identity

BetterTTY 1.0.0 is the first BetterTTY release and uses the codename **Andromeda**.

Release artifacts follow these names:

```text
bettertty_1.0.0_<arch>.deb
BetterTTY-1.0.0-Windows-x86_64-portable.zip
BetterTTY-1.0.0-macOS-x86_64.dmg
```

See `docs/RELEASE_NOTES_1.0.md`, `docs/BUILD_AND_TEST_1.0.md`, and `docs/TESTCASE_1.0.md`.

## Current file-manager limits

The SFTP file manager intentionally remains conservative. BetterTTY 1.0.0 does not yet implement:

- sync or mirror mode
- partial-transfer resume
- parallel transfers
- recursive deletion of non-empty directories
- rename, chmod, or chown
- permission/timestamp preservation during transfer
- symlink following during recursive folder transfer

See `docs/KNOWN_LIMITATIONS.md`.

## Project structure

```text
src/                 Qt/C++ application source
resources/           icons, platform resources, bundled xterm.js assets
scripts/             build, deployment, package, and checksum helpers
packaging/           package-maintainer scripts and packaging assets
docs/                BetterTTY documentation
examples/             sanitized example configuration
```

## Open source

BetterTTY is released under the **MIT License**. See `LICENSE`.

Contributions and issue reports are welcome. Never attach passwords, private keys, or a real `BetterTTY.json` containing secrets to an issue.

If BetterTTY saves you time, supporting its development is entirely optional. The project is intended to remain free and open source. The application links to `https://bettertty.dev/support` from the Help menu.
