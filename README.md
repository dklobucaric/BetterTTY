# BetterTTY

**A better way to SSH.**  
*Your servers. One dock.*

BetterTTY is a cross-platform desktop SSH client, saved-session manager, and two-panel SFTP file manager. It is built with **C++20, Qt 6, CMake, libssh, and an offline-bundled xterm.js terminal**.

| Project | Details |
| --- | --- |
| Current source version | **1.0.2 — Andromeda (source snapshot; packaging validation pending)** |
| Baseline / history | **1.0.0 — Andromeda**; 1.0.1 was an internal development series, not a separately verified release |
| Verification | Windows workflows user-tested on 1.0.1-dev; Linux/macOS builds and final 1.0.2 packages are **pending** |
| Website | [bettertty.dev](https://bettertty.dev) |
| Developer / publisher | DD-LAB |
| Copyright | © 2026 Dalibor Klobučarić |
| License | [MIT](LICENSE) |
| Target platforms | Windows, Linux, macOS (see [Platform status](#platform-status-and-packaging)) |

> **Documentation policy:** This README is the single entry point for *what the current app does, what every user-facing setting means, and what it does not yet do*. The files in [`docs/`](docs/INDEX.md) provide implementation details and extended instructions. A planned feature is **not** an implemented feature; a suspected bug is **not** a fixed bug.

## Contents

- [At a glance](#at-a-glance)
- [Getting started](#getting-started)
- [Screenshots (capture checklist)](#screenshots-capture-checklist)
- [Application layout and menus](#application-layout-and-menus)
- [SSH sessions and authentication](#ssh-sessions-and-authentication)
- [Host-key verification](#host-key-verification)
- [Terminal and keyboard controls](#terminal-and-keyboard-controls)
- [SFTP file manager and transfer queue](#sftp-file-manager-and-transfer-queue)
- [All settings explained](#all-settings-explained)
- [Configuration, backup, and recovery](#configuration-backup-and-recovery)
- [Session Traffic and diagnostics](#session-traffic-and-diagnostics)
- [Security and privacy](#security-and-privacy)
- [What BetterTTY cannot do yet](#what-bettertty-cannot-do-yet)
- [Platform status and packaging](#platform-status-and-packaging)
- [Building from source](#building-from-source)
- [Changes and bugfixes — 1.0.2](#changes-and-bugfixes--102)
- [Reporting bugs and requesting features](#reporting-bugs-and-requesting-features)
- [Project structure and documentation](#project-structure-and-documentation)
- [License and support](#license-and-support)

## At a glance

**Implemented in the 1.0.2 source tree** (platform verification varies):

| Area | Functionality | Status |
| --- | --- | --- |
| Session manager | Save, group, open, edit, and delete SSH profiles | Implemented |
| Login | SSH password or private-key authentication | Implemented |
| SSH trust | Verify unknown/changed host keys before authenticating; support multiple trusted algorithms per host and port | Implemented |
| Terminal | Multiple tabs, xterm.js renderer, shell input, PTY resize, paste, copy, disconnect/reconnect; optional paste confirmation (off by default) | Implemented |
| Alternate shell | Basic text-based SSH shell for fallback/debug use | Implemented; limited |
| SFTP | Local/remote browsing, file upload/download, transfer queue | Implemented |
| Folder transfers | Recursively scan folders and add their contents to the queue | Experimental/conservative |
| Transfer controls | Sequential runs, overwrite/skip decisions, retries, queue management | Implemented |
| File deletion | Queue local/remote files, links, or empty directories for confirmed deletion | Implemented; limited |
| Configuration | JSON export/import, backup/restore, corruption recovery | Implemented |
| Appearance | Light (default) / Dark application UI and terminal font configuration | Implemented; limited |
| Monitoring | Application-level SSH/SFTP session traffic counters | Implemented |
| Diagnostics | Opt-in event logging with an open-log-folder action | Implemented |
| Multi-Exec | Menu/toolbar entry only; no command broadcast | **Not implemented** |
| Encrypted credential vault | Master-password/encrypted at-rest secrets | **Not implemented** |

The presence of an action or placeholder in the UI does not mean its proposed future behavior is already supported.

## Getting started

1. Build or install a suitable BetterTTY package; launch the application.
2. Open **Session → New Session**.
3. Enter **Host**, **Port**, **Username**, **Auth type**, credentials, a **Session name**, and optionally a **Group**.
4. Approve the SSH host key **only after verifying its fingerprint** against a trusted source.
5. After a successful authentication test, the saved profile appears in the left sidebar.
6. **Double-click** a saved session to open its xterm.js SSH terminal.
7. **Right-click → Open file manager** to open SFTP for that saved session.

**Temporary/test-only connection:** **Session → Connect / Auth test** opens a manual connection dialog in which saving is optional.

See [Getting Started](docs/GETTING_STARTED.md) and [User Guide](docs/USER_GUIDE.md).

## Screenshots (capture checklist)

Screenshots are intentionally **placeholders until captured from final builds**. This avoids embedding old `-dev` UI or exposing production credentials. Each placeholder below has an exact filename, frame suggestion and redaction rules in [docs/SCREENSHOTS.md](docs/SCREENSHOTS.md).

| Placeholder | Capture | Planned file |
| --- | --- | --- |
| `SCREENSHOT:WELCOME` | Welcome + What's New | `docs/screenshots/01-welcome.png` |
| `SCREENSHOT:SESSIONS` | Sidebar with grouped sessions | `docs/screenshots/02-session-groups.png` |
| `SCREENSHOT:CONNECTION` | New/Edit Session fields (demo credentials only) | `docs/screenshots/03-connection-dialog.png` |
| `SCREENSHOT:HOST-TRUST` | SSH host-key decision dialog (test server) | `docs/screenshots/04-host-key-verification.png` |
| `SCREENSHOT:TERMINAL` | Connected xterm.js shell and tabs | `docs/screenshots/05-terminal-tabs.png` |
| `SCREENSHOT:PASTE` | Right-click menu + paste settings | `docs/screenshots/06-terminal-copy-paste.png` |
| `SCREENSHOT:SFTP` | Local/remote panels | `docs/screenshots/07-sftp-file-manager.png` |
| `SCREENSHOT:QUEUE` | Transfer queue and progress | `docs/screenshots/08-sftp-transfer-queue.png` |
| `SCREENSHOT:SETTINGS` | Light/Dark, each settings page | `docs/screenshots/09-settings-light.png` through `14-settings-security.png` |
| `SCREENSHOT:ABOUT` | Version 1.0.2 About window | `docs/screenshots/15-about-version.png` |

<!-- SCREENSHOT PLACEHOLDERS: replace with image links only after redacted images exist. -->

## Application layout and menus

The main window has a **left sidebar** with saved sessions, a **right tab area** for terminals and file managers, an optional **quick action toolbar**, and a **status bar** for connection/traffic/diagnostic information. Tabs can be opened, selected, reordered, and closed.

### File menu

| Action | What it does |
| --- | --- |
| **Open Config Folder** | Opens the directory containing the active `BetterTTY.json`. |
| **Export Config...** | Exports the **entire** current configuration, potentially including plaintext credentials. |
| **Import Config...** | Previews/validates a JSON configuration, asks for confirmation, makes a pre-import backup, and replaces the active configuration. |
| **Restore Latest Backup...** | Restores the newest valid rotating backup, moving the current config aside first. |
| **Exit** | Exits the application, with a confirmation when relevant active work/sessions exist. |

### Session menu

| Action | What it does |
| --- | --- |
| **New Session** | Tests credentials and saves a new profile only after successful authentication. |
| **Connect / Auth test** | Performs a manual SSH connection/authentication test; saving is optional. |
| **Edit selected session** | Edits the currently selected saved profile in the sidebar. |
| **Next Tab (`Ctrl+Tab`)** | Switches to the next tab, wrapping to the first tab at the end; does not reconnect active sessions. |

**Right-clicking a saved session** offers: **Open terminal**, **Open file manager**, **Run auth test**, **Open fallback shell**, **Edit session**, and **Delete session**. Double-clicking always opens the regular terminal in the current release.

### Tools menu

| Action | What it does |
| --- | --- |
| **Multi-Exec** | **Placeholder only**. Currently shows a status message; does *not* send commands to multiple servers. |
| **Settings** | Opens BetterTTY's General, Diagnostics, Appearance, Terminal, Config safety, and Security note pages. |

### Help menu

| Action | What it does |
| --- | --- |
| **BetterTTY Website** | Opens `https://bettertty.dev`. |
| **Support BetterTTY** | Opens `https://bettertty.dev/support`. |
| **About BetterTTY** | Shows application/build identity, libssh version, config path, and log path. |
| **Open Log Folder** | Opens the diagnostic log directory. |

The optional toolbar duplicates **New Session**, **Connect**, **Multi-Exec** (placeholder), and **Settings**; disabling it does not remove the menu actions.

## SSH sessions and authentication

### Connection dialog fields

| Field / control | Meaning |
| --- | --- |
| **Host** | SSH server DNS name or IP address. Required. |
| **Port** | TCP port, **1–65535**; default **22**. |
| **Username** | Remote SSH account name. Required. |
| **Auth type: Password** | Authenticates with the entered password. |
| **Auth type: Private key** | Selects a local private-key file; when saved, its content is copied into the plaintext config secrets collection. |
| **Password** | Required for a new password-based session; blank during an edit retains the stored secret. |
| **Private key / Browse...** | Selects a private-key file; blank during an edit retains the stored key. |
| **Save this connection after successful auth** | In manual **Connect / Auth test**, **unchecked by default**. Check to save a profile if authentication succeeds. |
| **Session name** | Display name for a saved profile. Required when saving; can be suggested from `username@host:port`. |
| **Group** | Optional text used to organize profiles in the sidebar. |

The save checkbox depends on dialog mode:

- **New Session:** checked and locked on; a new profile is saved only after successful authentication.
- **Connect / Auth test:** user-selectable, off by default; the test can be performed without storing a profile.
- **Edit session:** checked and locked on; saves edits to the existing profile. Leaving its password/key input empty retains the previous secret.

BetterTTY warns about duplicate `username@host:port` targets. Sessions can be edited and removed. Removing a session does **not** automatically remove its host-key trust record because several profiles might use the same host/port.

### Connection lifecycle

The application checks the SSH host key, performs authentication, and then opens the requested terminal or SFTP view. A dropped terminal session can be reconnected from its tab. Closing the application with connected tabs invokes an exit-safety check; ongoing SFTP/queue work also has close-safety handling. A connection test is not a general port/network scanner.

## Host-key verification

BetterTTY verifies SSH server identity **before sending credentials**:

- **Unknown host:** presents its key/fingerprint for an explicit trust decision.
- **Known host and matching algorithm/fingerprint:** continues as trusted.
- **Known host, additional algorithm:** offers a separate decision to trust the additional legitimate key type.
- **Existing algorithm with a changed fingerprint:** displays a prominent warning; the key is never silently replaced.

Trust is recorded by **`host:port`** with potentially multiple key algorithms in `BetterTTY.json`. Verify unexpected changes with your server administrator or a separately trusted source. This is a host-identity trust mechanism, **not** a certificate authority or automatic proof that a newly encountered server is safe.

See [Known Hosts Portability Test](docs/KNOWN_HOSTS_PORTABILITY_TEST.md) and [Config Format](docs/CONFIG_FORMAT.md).

## Terminal and keyboard controls

The primary SSH terminal uses **xterm.js inside Qt WebEngine**, connected to libssh through Qt WebChannel. Its JavaScript/CSS assets ship with the application, so normal rendering does not require a runtime CDN. It supports interactive screen-oriented programs such as `htop`, `top`, `nano`, and `vim`, UTF-8 stream decoding, remote input, and SSH PTY resize updates.

### Standard xterm.js terminal buttons

| Button | What it does |
| --- | --- |
| **Copy** | Copies selected terminal text to the clipboard. **It does not send Ctrl+C.** |
| **Paste** | Pastes clipboard text using **Settings → Terminal → Paste mode** (Automatic / Legacy / Slow Paste). Existing clipboard line endings are preserved semantically; no extra final Enter is added. |
| **Clear** | Clears the **local displayed terminal contents**; it does not run remote `clear`. |
| **Reset** | Resets the **local renderer state** when display/full-screen rendering becomes confused; it does not reboot the server or reconnect SSH. |
| **Focus** | Returns keyboard focus to the terminal. |
| **Reconnect** | Reopens the SSH shell using the session's stored credentials after disconnection. |
| **Disconnect** | Disconnects the active SSH shell. |

Keyboard/paste behavior:

- **Ctrl+Tab:** cycles to the next BetterTTY tab (terminal, SFTP, Welcome or status tab), wrapping from last to first; **Session → Next Tab** offers the same action. Tested by the Windows user. **Ctrl+Shift+Tab is not an advertised/supported reverse-navigation shortcut in 1.0.2**; the reverse-navigation path from the previous development snapshot was inconsistent on Windows and has been removed from BetterTTY-specific bindings. Switching tabs does not reconnect or terminate SSH.
- **Ctrl+C inside the focused terminal:** remote interrupt, not the toolbar Copy action.
- **Select terminal text with the mouse:** copied automatically to the OS clipboard when **Automatically copy selected text** is enabled (default **On**); no Copy click required. Releasing the left mouse button completes the selection. This may overwrite clipboard contents (including sensitive text); disable the option if you prefer manual copying.
- **Right-click → Copy, toolbar Copy and Ctrl+Shift+C:** manual Copy always works, regardless of the Auto Copy setting. On macOS, Command+Shift+C also requests terminal Copy.
- **Ctrl+Shift+V (Windows/Linux)** and **Command+V (macOS):** BetterTTY's native safe-paste route.
- Toolbar Paste and supported context-menu paste use the same Qt clipboard route and configured mode.
- **Automatic (default):** xterm.js uses Bracketed Paste (`ESC [ 200 ~` / `ESC [ 201 ~`) **only if the remote program requested it** (`DECSET 2004`); this avoids treating a whole paste as separate submissions in capable TUIs such as Hermes. Otherwise xterm.js sends regular CR-delimited input.
- **Legacy:** sends plain CR-delimited terminal input, preserving existing line breaks but **not** adding a final Enter. In prompts and shells, pasted newlines may execute commands or submit messages.
- **Slow Paste:** same plain CR-delimited input as Legacy, but a timer sends at most **128 UTF-16 code units / one Enter per 50 ms**; typing during a paced paste cancels its remaining queued input. This is for compatibility with programs that cannot keep up with large bursts. It **does not** guarantee that a TUI treats all lines as a single message or prevent command execution.
- Even Automatic can execute commands when the remote program has **not** enabled Bracketed Paste. Inspect multiline clipboard text before pasting into privileged shells.

**Fallback shell:** **Open fallback shell** presents a basic text output/input view with **Send**, **Interrupt**, **Clear**, and **Disconnect**. It is a fallback/debug interface, **not** a full replacement for xterm.js's terminal-emulator behavior.

## SFTP file manager and transfer queue

Right-click a **saved** session and choose **Open file manager**. The graphical manager uses **libssh SFTP APIs**, not text scraping of terminal commands.

### Two-panel browsing

| Local panel | Remote panel |
| --- | --- |
| Shows local files and folders | Shows remote SFTP files and folders |
| Editable **Local path**, **Go**, **↑ Up**, **Refresh** | Editable **Remote path**, **Go**, **↑ Up**, **Refresh** |
| Double-click navigates folders | Double-click navigates folders |
| **Queue upload** adds selected local files/folders | **Queue download** adds selected remote files/folders |
| **Delete local** queues supported local deletions | **Delete remote** queues supported remote deletions |

The views are browsing interfaces; unsupported edit operations such as rename or chmod cannot be performed there. File transfers and deletions use a **queue-first** workflow.

### Transfer behavior

1. Select one or more files or folders and choose **Queue upload** or **Queue download**.
2. For folders, BetterTTY requests confirmation, recursively scans eligible descendants, and expands them into queue entries. **Folder transfer is experimental**, and symbolic links are skipped during recursive traversal.
3. Review the queue's **Status**, **Direction**, **Name**, **Size**, **Source**, and **Target** columns.
4. Select **Start queue**. Items are processed **one at a time**, rather than in parallel.
5. On a target-file conflict, select **Overwrite**, **Skip**, **Overwrite all**, **Skip all**, or stop/cancel the queue as offered by the dialog.
6. Inspect transfer progress/results; the application refreshes local and remote panels after a run.

| Queue button | Meaning |
| --- | --- |
| **Start queue** | Executes pending operations sequentially. |
| **Retry selected** | Returns selected **Done**, **Failed**, **Cancelled**, or **Skipped** entries to **Pending**; this retries from the start, **not** from an interrupted byte offset. |
| **Remove selected** | Removes selected entries from the list when editing is allowed; it is not a delete-files command. |
| **Clear finished** | Removes finished entries from the displayed queue. |

Queue status labels distinguish **Pending**, **Done**, **Failed**, **Cancelled**, and **Skipped**. Relevant controls/navigation are restricted while the queue runs.

### Deletion, overwrite, and data safety

- **Delete local** / **Delete remote** add eligible regular files, links, or **empty directories** to the queue. Deletion is **not** recursive for non-empty folders.
- Destructive delete operations require explicit confirmation, including a confirmation before execution.
- A **download** uses a safe temporary local file so an interrupted download should not replace an existing local target.
- **Important:** a cancelled/failed **upload** can leave a partial remote file; **overwriting an existing remote file is not yet crash-safe**. Verify/back up important targets before overwriting. Remote overwrite atomicity is **not implemented** in 1.0.2.
- No transfer-resume capability exists; retrying starts an item again.
- The SFTP feature set is intentionally conservative. Server permissions, SFTP subsystem support, and connectivity can limit operations.

See [File Transfer Architecture](docs/FILE_TRANSFER_ARCHITECTURE.md) and [Known Limitations](docs/KNOWN_LIMITATIONS.md).

## All settings explained

Open **Tools → Settings**. These settings live under the top-level `settings` object in `BetterTTY.json`. Click **OK** to save or **Cancel** to discard dialog changes.

### General

| UI control | Default / choices | Exact meaning |
| --- | --- | --- |
| **Config file** | Read-only path | Shows the active `BetterTTY.json`; this field cannot be edited here. |
| **Copy path** | Button | Copies the config file path to the clipboard. |
| **Open folder** | Button | Opens its containing folder in the system file manager. |
| **Double-click session** | **Open terminal** (fixed) | Double-clicking a saved profile opens xterm.js. This is currently a **display-only** option, not a selectable action. SFTP is in the right-click menu. |
| **Show quick action toolbar** | **Off** by default | **On:** shows New Session, Connect, Multi-Exec placeholder, Settings shortcuts above the main window. **Off:** hides those shortcuts; menu actions remain available. |

### Diagnostics

| UI control | Default | Exact meaning |
| --- | --- | --- |
| **Enable diagnostic logging** | **Off** | **On:** writes application/connection/queue/error metadata and useful lifecycle diagnostics to the log folder. **Off:** stops optional diagnostic event logging. It does **not** intentionally log passwords, private keys, file contents, terminal input/output, or clipboard text. |

Use **Help → Open Log Folder** to locate log files. Logs may contain hostnames, usernames, paths, fingerprints, sizes, and other operational metadata. No automatic log pruning is implemented in 1.0.2.

### Appearance

| UI control | Default / values | Exact meaning |
| --- | --- | --- |
| **App theme** | **Light** (`light`, default), **Dark** (`dark`) | Sets the **Qt application interface** theme. Existing `system` values are treated as Light; an existing Dark preference is kept. The xterm.js terminal keeps its dark renderer. |

### Terminal

| UI control | Default / range | Exact meaning |
| --- | --- | --- |
| **Font family** | `monospace` | Font-family name for **newly opened xterm.js tabs**. Prefer an installed monospace font. Existing tabs are unchanged. |
| **Font size** | **14**, range **8–36** | Font size for **newly opened xterm.js tabs**; existing tabs do not update live. |
| **Paste mode** | **Automatic** (`automatic`); **Legacy** (`legacy`); **Slow Paste** (`slow`) | **Automatic:** use the remote application's Bracketed Paste negotiation via xterm.js. **Legacy:** plain terminal input without framing. **Slow Paste:** plain input paced in small chunks every 50 ms; typing, changing mode or disconnecting cancels unsent chunks. Takes effect in open and new tabs after **OK**. Stored in `settings.terminal.paste_mode`. |
| **Automatically copy selected text** | **On** (checkbox) | After a mouse selection finishes in the SSH terminal, copy its plain text into the standard OS clipboard. **Off:** selecting alone never copies; right-click **Copy**, toolbar **Copy** and **Ctrl+Shift+C** still work. Does not affect Paste or SFTP. Applies to existing and new tabs after saving. Config key: `settings.terminal.copy_on_select`. May overwrite previous clipboard contents, including secrets. |
| **Show paste notifications** | **Off** (checkbox) | **Off:** paste sends clipboard text to the SSH shell without printing the `[BetterTTY] Sent clipboard text...` confirmation. **On:** prints the existing confirmation with character and line counts. The setting takes effect immediately in both open and new terminal tabs after clicking **OK**; clipboard-paste behavior, SSH errors, and other status messages remain unchanged. |

### Config safety

| UI control | Default / range | Exact meaning |
| --- | --- | --- |
| **Enable config backups before save** | **On** | **On:** create timestamped, rotating `BetterTTY.json.bak-*` backups before normal config saves. **Off:** disable that routine pre-save backup behavior; do **not** interpret this as disabling all special safety backups during import/restore. |
| **Keep last** | **10**, range **1–50** | Maximum number of regular rotating config backups retained; older ones are pruned as the limit is exceeded. |

**Note:** Backups can contain exactly the same plaintext secrets as the active config. Protect them accordingly.

### Security note

The **Security note** page is **informational**, not a toggle. It warns that `secrets.mode = plain-v1` stores saved password and private-key values in **human-readable form** in the JSON file and its copies. There is **no** built-in encryption/master-password checkbox in 1.0.2.

### Other checkbox: Connect / Auth test

The connection dialog's **Save this connection after successful auth** checkbox is documented under [SSH sessions and authentication](#ssh-sessions-and-authentication). It is **not** a global Settings preference.

## Configuration, backup, and recovery

BetterTTY uses a platform-specific Qt application configuration folder for **`BetterTTY.json`** (identity: **DD-LAB / BetterTTY**). The **actual path displayed by Tools → Settings or Help → About BetterTTY is authoritative**.

The JSON document contains:

```text
app           product/config version metadata
settings      theme, font, paste-notification, backup, diagnostics, toolbar preferences
groups        session grouping data
sessions      saved connection profiles and references to secrets
known_hosts   trusted host-key fingerprints keyed by host:port
secrets       plain-v1 secret items (credentials / private-key contents)
metadata      application metadata
```

- **Export** copies the full configuration (not a sanitized/public session list).
- **Import** validates the selected JSON, presents a preview/warning, creates a pre-import backup, and replaces active profiles, secrets, known hosts, settings, and metadata.
- **Restore Latest Backup** selects a valid backup and moves the previous active file aside as `BetterTTY.json.pre-restore-*` before restoring it.
- **Corrupt config recovery** does not silently overwrite damaged JSON. Recovery choices include **Continue read-only**, **Restore latest valid backup**, **Create fresh config**, and **Open config folder**. A damaged file is preserved under a `BetterTTY.json.corrupt-*` name when applicable.
- Example public/test configuration: [`examples/BetterTTY.example.json`](examples/BetterTTY.example.json). **Never use real credentials in committed examples.**

Read [Config Management](docs/CONFIG_MANAGEMENT.md), [Config Format](docs/CONFIG_FORMAT.md), and [Config Import/Export Safety](docs/CONFIG_IMPORT_EXPORT_SAFETY.md).

## Session Traffic and diagnostics

The status bar displays activity for the **currently active** terminal or file-manager tab:

- **Received:** SSH shell-channel bytes read by BetterTTY and SFTP downloaded file bytes.
- **Sent:** SSH shell-channel bytes written by BetterTTY and SFTP uploaded file bytes.
- The active tab determines which session's rates and totals appear.
- **Not included:** traffic by other applications, system-wide bandwidth, protocol overhead, or ordinary SFTP listings/metadata as bulk transfer bytes.

Diagnostic logging is **optional/off by default**. When enabled, it records diagnostic event metadata rather than a terminal transcript. Log files are per-day; 1.0.2 does not automatically prune them. See [Session Traffic](docs/SESSION_TRAFFIC.md) and [Logging](docs/LOGGING.md).

## Security and privacy

> **Important — plaintext credentials:** The 1.0.2 configuration deliberately uses `secrets.mode = plain-v1`. Saved SSH **passwords** and **private-key contents** may be stored as readable JSON. **This is not encrypted credential storage.** Use only on trusted computers, protect the config and backups with OS file permissions, and never publish real config files, keys, or logs.

Other security properties and limits:

- SSH host identity is verified **before authentication**; do not blindly accept unknown/changed fingerprints.
- SFTP deletes require explicit confirmation; full-folder recursive delete is intentionally unsupported.
- Logs are designed not to contain credential values, terminal I/O, clipboard data, file contents, or complete config contents. They **may** include metadata such as server names, usernames, paths, and key fingerprints; inspect before sharing.
- An exported config is a **sensitive backup**, not a redacted shareable profile bundle.
- No encrypted credential vault, secure cross-device key exchange, or master password is currently implemented.

See [Security Notes](docs/SECURITY_NOTES.md).

## What BetterTTY cannot do yet

This section is as important as the feature list. These are **current limitations of the 1.0.2 source**; do not confuse planned work with shipping features.

| Area | Not supported / current constraint |
| --- | --- |
| **Multi-Exec** | No command broadcast to multiple terminals; UI item is a placeholder. |
| **Credential encryption** | No master password, encrypted secrets vault, or OS credential-manager storage in the current `plain-v1` model. |
| **SFTP synchronization** | No sync/mirror or bidirectional reconciliation. |
| **SFTP resume** | No partial-transfer resume or byte-range continuation; retries start again. |
| **SFTP concurrency** | No parallel file transfers; queue runs sequentially. |
| **SFTP destructive operations** | No recursive deletion of non-empty directories. |
| **SFTP editing/metadata** | No rename, chmod, chown, permission/timestamp preservation, or built-in remote file editing. |
| **Recursive links** | Symbolic links are not followed while recursively queueing folder transfers. |
| **Upload atomicity** | An interrupted remote upload/overwrite can leave partial or altered data; do not assume remote writes are atomic. |
| **Terminal look and feel** | Terminal renderer does not follow Qt light/dark theme; saved font changes affect new tabs only. |
| **Sidebar default** | Double-click behavior cannot currently be changed to open SFTP. |
| **Traffic display** | Application-session bytes only, **not** global OS network monitoring. |
| **Diagnostic log viewer** | Opens the log directory externally; there is no integrated log viewer or automatic log retention. |
| **Distribution** | Microsoft Store packaging is planned, not shipped in the original 1.0.0 source; macOS signing/notarization is separate. |

See [Known Limitations](docs/KNOWN_LIMITATIONS.md) and [Roadmap](docs/ROADMAP.md) for future candidates. A roadmap item is not a release commitment.

## Platform status and packaging

**Windows:** pre-1.0.2 development snapshots were built and interactively tested by the maintainer. The final 1.0.2 source/package still requires a clean Windows rebuild, CLI and GUI regression, and a clean-machine portable ZIP test.

**Linux:** native CMake and Debian `.deb` build/installation are **not yet validated for 1.0.2**. Linux desktop and Qt WebEngine dependencies vary by distribution.

**macOS:** native `.app` and `.dmg` helpers exist, but 1.0.2 builds, dependency audits and macOS Gatekeeper distribution have **not** been validated. DMG does not automatically mean signed/notarized. Intel and Apple Silicon require matching builds.

See [Build and Package 1.0.2](docs/BUILD_1.0.2.md), [Release Status](docs/RELEASE_STATUS_1.0.2.md), [QA Matrix](docs/QA_MATRIX_1.0.2.md) and [Release Artifacts](docs/RELEASE_ARTIFACTS.md).

## Building from source

Requirements:

- **CMake 3.24+** and a **C++20** compiler
- **Qt 6** modules: Core, Widgets, WebEngineWidgets, WebChannel
- **pkg-config / pkgconf** and **libssh** development libraries
- Platform-appropriate build tools (**MSVC** on Windows per project guide; compiler/Ninja on Linux and macOS)

Example Linux build:

```bash
cmake -S . -B build -G Ninja
cmake --build build
./build/bettertty
```

Or use the repository's `scripts/linux-build-release.sh`. On Windows, follow the [Windows Build Guide](docs/WINDOWS_BUILD.md) for the Qt/MSVC/vcpkg configuration and [Windows Deployment](docs/WINDOWS_DEPLOYMENT.md) for bundled DLLs and `windeployqt`.

A successful CMake build alone does not prove SSH, terminal, SFTP, config recovery, or portable Windows deployment are working. Use the [1.0.2 QA matrix](docs/QA_MATRIX_1.0.2.md) and [platform build guide](docs/BUILD_1.0.2.md).

### Build identification, terminal menu and visual consistency (1.0.2)

- **Help → About BetterTTY** displays runtime version **`1.0.2`**, codename, milestone, build label, libssh version and local configuration/log paths. Windows EXE version resources are generated from the same CMake numeric version. Source ZIPs display build label `source-archive`; Git builds show the short commit ID and `-dirty` for uncommitted changes. This label is *not* a validation/certification guarantee.
- **Welcome** lists the 1.0.2 What's New & Bugfixes summary. Platform qualification remains explicit in [release status](docs/RELEASE_STATUS_1.0.2.md).
- **SSH terminal right click** opens a BetterTTY-specific **Copy**, **Paste**, **Select All**, **Clear Terminal** menu. Paste is plain text and respects the existing three Settings → Terminal modes. **Edit → Paste**, toolbar Paste and keyboard paste share that same logic. Rich-text/web formatting is not supported.
- **Application themes:** Light is the new default, Dark remains selectable. `system` values from older configs are interpreted as Light, but reading them does not silently overwrite user files. The terminal renderer itself remains dark.
- **Readability:** Light Settings titles/labels are dark (`#111827`) and descriptions gray (`#667085`); Dark labels are white (`#FFFFFF`) and descriptions light gray (`#B8C0CC`). Both themes have explicit tab-close icons.

## Changes and bugfixes — 1.0.2

**Current source version:** `1.0.2`. This consolidates the tested Windows workflows developed during the untagged `1.0.1-dev` series. A version string is **not** a claim that the source has passed final Windows packaging, Linux or macOS release qualification. See [release status](docs/RELEASE_STATUS_1.0.2.md), [release notes](docs/RELEASE_NOTES_1.0.2.md) and the [full changelog](docs/CHANGELOG.md).

| Issue | What changed | Validation status |
| --- | --- | --- |
| **FR-001** | Paste notification checkbox, **Off** by default | User-tested on Windows (earlier dev build) |
| **FR-002** | Consistent About/Welcome version and build labels | Needs final 1.0.2 recheck |
| **BUG-003 / FR-003** | Automatic, Legacy and Slow Paste modes, no synthetic trailing Enter | Hermes multiline/integrity user tests passed on Windows |
| **FR-004** | Terminal-specific context menu; one Paste path | Windows user testing reported working |
| **BUG-005** | Close-X contrast in Light/Dark tabs | Windows visual testing reported working |
| **BUG-006** | Light/Dark settings label and description contrast | Windows visual testing reported working |
| **FR-007** | Light and Dark only; Light default, old System maps to Light | Windows visual testing reported working; config migration needs recheck |
| **BUG-008** | Visible checked/unchecked Settings checkbox icons | Windows user reported functional after fix |
| **FR-009** | Select-to-Copy **On** by default, manual Copy always supported | Windows user demonstrated multiline clipboard persistence after tab close |
| **FR-010** | **Ctrl+Tab** cycles forward across open tabs | Windows user validated; reverse Ctrl+Shift+Tab is intentionally not advertised |

**Risk disclosure:** remote SFTP overwrite is not transactional; credentials/private-key material are stored readable (`plain-v1`) by design. Neither issue is resolved by 1.0.2. Do not store sensitive profiles on untrusted machines or assume interrupted uploads are atomic.

Historical 1.0.0 notes and the original development issue list remain in [`docs/CHANGELOG.md`](docs/CHANGELOG.md) and [`BUGS.md`](BUGS.md).

## Reporting bugs and requesting features

Use the existing repository templates:

- [Bug report](.github/ISSUE_TEMPLATE/bug_report.md) — include OS/build, exact steps, expected/actual results, and non-sensitive screenshots/logs.
- [Terminal issue](.github/ISSUE_TEMPLATE/terminal_issue.md) — terminal behavior, keystrokes, renderer symptoms, and remote environment.
- [Config recovery issue](.github/ISSUE_TEMPLATE/config_recovery_issue.md) — backup/restore/import behavior; **redact secrets**.
- [Feature request](.github/ISSUE_TEMPLATE/feature_request.md) — proposed behavior, user impact, and acceptance criteria.

Please **never attach** real passwords, private keys, or an unredacted `BetterTTY.json`. Server/user/path metadata in diagnostic logs can also be sensitive.

Suggested change workflow: **issue → investigation → focused patch → review/test → README and changelog update → release archive**. The original 1.0.0 source stays a preserved baseline.

## Project structure and documentation

```text
src/ui/              Main window, dialogs, terminal tabs, SFTP UI
src/core/            Configuration, saved profiles, host keys, diagnostics
src/ssh/             SSH connection, compatibility, shell worker
src/sftp/            SFTP protocol operations
resources/           Icons, Qt resources, xterm.js, platform assets
scripts/             Build, deploy, portable package, checksum helpers
packaging/           Platform-specific packaging assets
examples/            Non-sensitive example JSON configuration
docs/                Extended user/developer/release documentation
.github/             Issue and pull-request templates
CMakeLists.txt        Build and version source
README.md            Single entry point: features, settings, limits, patch log
LICENSE              MIT license
```

Useful detailed references:

- [Documentation index](docs/INDEX.md)
- [Architecture](docs/ARCHITECTURE.md)
- [User Guide](docs/USER_GUIDE.md)
- [Config Format](docs/CONFIG_FORMAT.md)
- [Security Notes](docs/SECURITY_NOTES.md)
- [Known Limitations](docs/KNOWN_LIMITATIONS.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Release Process](docs/RELEASE_PROCESS.md)
- [Build 1.0.2](docs/BUILD_1.0.2.md)
- [Release Status 1.0.2](docs/RELEASE_STATUS_1.0.2.md)
- [QA Matrix 1.0.2](docs/QA_MATRIX_1.0.2.md)
- [Screenshots and safe capture](docs/SCREENSHOTS.md)
- [Changelog](docs/CHANGELOG.md)

**Documentation maintenance rule:** When a control changes in the C++ UI, update its explanation here; when a feature is implemented/removed, update **At a glance**, **What BetterTTY cannot do yet**, and the relevant detailed guide. Never describe a planned feature as released.

## License and support

BetterTTY is free and open source under the **[MIT License](LICENSE)**. Contributions and useful bug reports are welcome. Supporting development is optional: [bettertty.dev/support](https://bettertty.dev/support).

**Version 1.0.2 native-build guide:** [Windows, Debian and macOS commands](docs/BUILD_1.0.2.md). **Platform test evidence:** [Release status](docs/RELEASE_STATUS_1.0.2.md), [QA matrix](docs/QA_MATRIX_1.0.2.md).

**DD-LAB · BetterTTY — A better way to SSH.**
