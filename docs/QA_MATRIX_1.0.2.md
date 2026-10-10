# BetterTTY 1.0.2 — cross-platform test matrix

Fill in **PASS / FAIL / NOT RUN** per platform, with tested distribution, CPU architecture, Qt/libssh versions, a timestamp, and build ID. Never mark a test PASS because a comparable test passed on a different OS.

| Test | Windows 11 | Linux (distro/DE) | macOS (version/arch) |
| --- | --- | --- | --- |
| Clean compile and application launch | Pending 1.0.2 | Pending | Pending |
| About shows 1.0.2, build ID | Pending | Pending | Pending |
| Group/create/edit/delete saved sessions | Pending | Pending | Pending |
| Password SSH auth and private-key SSH auth | Pending | Pending | Pending |
| Host-key unknown/matching/changed handling | Pending | Pending | Pending |
| SSH shell interactive input, resize, reconnect/disconnect | Pending | Pending | Pending |
| Hermes TUI multiline (Automatic) | Prior-dev positive, rerun | Pending | Pending |
| Legacy and Slow Paste; cancellation; Ctrl+C | Pending | Pending | Pending |
| Paste notification on/off + persistence | Pending | Pending | Pending |
| Auto Copy on/off + clipboard persistence | Prior-dev positive, rerun | Pending | Pending |
| Right-click Copy/Paste and Ctrl+Shift+C | Pending | Pending | Pending |
| Ctrl+Tab with xterm.js focus + wraparound | Prior-dev positive, rerun | Pending | Pending |
| Light/Dark settings contrast, checkbox and tab X | Prior-dev positive, rerun | Pending | Pending |
| SFTP browse + upload/download (including folders) | Pending | Pending | Pending |
| SFTP overwrite/cancel and confirmed delete safety | Pending | Pending | Pending |
| JSON import/export/restore and corrupt recovery | Pending | Pending | Pending |
| Clean package install, launch, uninstall | Pending | Pending | Pending |
| No real secrets in distributable package | Pending | Pending | Pending |

**Important cross-platform checks:** clipboard behavior through Qt on X11/Wayland/macOS; shortcuts when QtWebEngine has focus; macOS macdeployqt, bundled Homebrew dylibs and Gatekeeper; Linux `.deb` dependencies and QtWebEngine sandbox; Windows portable DLL verification. Keep network tests on a non-production server.
