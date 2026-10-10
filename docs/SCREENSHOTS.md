# BetterTTY 1.0.2 — Screenshot capture plan

**Status: PLACEHOLDERS ONLY.** Do not commit raw private screenshots. Replace each placeholder only after reviewing for server names, IP addresses, usernames, passwords, private keys, host fingerprints, sensitive paths and production file names. Use a **dedicated demo SSH account and non-sensitive data** when possible. Prefer PNG, consistent dimensions and 100% Windows DPI if feasible; do not fake a successful operation in screenshots.

The README intentionally lists names but no broken Markdown images. Once files exist, add `![Meaningful alt text](screenshots/name.png)` here and optionally small previews to the README.

| Filename | Where/how to capture | What user should see |
| --- | --- | --- |
| `01-welcome.png` | Launch BetterTTY 1.0.2, choose Welcome tab | Brand, release features, quick start |
| `02-session-groups.png` | Main window with **demo** group hierarchy (expand 2 groups) | Saved session/group organization and right tabs |
| `03-connection-dialog.png` | Session → New Session, use fake `demo.example.org` and a fake username, no real secrets | Host, port, username, auth, optional group/save |
| `04-host-key-verification.png` | Connect to owned test host with fingerprint manually verified and redacted if needed | First-connection trust/changed-key warning |
| `05-terminal-tabs.png` | Connect to test Linux host, 3 open tabs, terminal status shown | Tabbed xterm.js SSH and terminal toolbar |
| `06-terminal-copy-paste.png` | Right-click terminal with harmless selected log and include Settings → Terminal in separate image if needed | Copy, Paste, Selection, paste modes |
| `07-sftp-file-manager.png` | Open file manager on demo host; use non-sensitive local and remote folders | Local and remote panels, queue buttons |
| `08-sftp-transfer-queue.png` | Transfer small dummy files, capture queued/done entries | Sequential queue and status |
| `09-settings-light.png` | Tools → Settings → General, Light theme | Toolbar config, paths, theme-appropriate text |
| `10-settings-diagnostics.png` | Settings → Diagnostics, Light | Diagnostic logging toggle and description |
| `11-settings-appearance.png` | Settings → Appearance | Only Light/Dark theme choices |
| `12-settings-terminal.png` | Settings → Terminal | Font, all paste modes, Auto Copy, notifications |
| `13-settings-config-safety.png` | Settings → Config safety | Backups enabled and retention |
| `14-settings-security.png` | Settings → Security note | `plain-v1` human-readable credential warning |
| `15-about-version.png` | Help → About BetterTTY | Version 1.0.2, codename, build, libssh version |
| `16-dark-theme.png` | Main window + Settings in Dark | Readable text, checkbox contrast, tab close X |
| `17-session-traffic.png` | Active SSH tab with non-sensitive traffic | Session TX/RX counters (not global traffic) |
| `18-macos-app.png` | macOS only, after native test | `.app` and actual macOS runtime |
| `19-linux-app.png` | Linux only, after native test | BetterTTY on tested Linux desktop |

Recommended public screenshot set for README landing page: **01, 02, 05, 07, 12, 16**. Put the remainder in docs or website gallery later.

**Capture rules:** Never screenshot a real `BetterTTY.json` or backup. Never include credential values, token-bearing shell commands, or an unredacted host-key prompt with private infrastructure information. If a session name or IP is sensitive, recreate the screenshot with a demo profile rather than blurring some fields and missing others. Don't use private ChatGPT/Hermes transcripts without checking their contents.

Before merging photos into `main`: verify all images open, have descriptive alternative text, are not unnecessarily huge, and show the actual released UI rather than a mockup. `docs/screenshots/` is a placeholder folder; no fake screenshot image is included in this ZIP.
