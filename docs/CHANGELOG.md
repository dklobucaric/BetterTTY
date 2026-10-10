# BetterTTY changelog

## 1.0.2 — Andromeda (source milestone; release qualification in progress)

Contains the user-tested functionality developed on the `1.0.1-dev` branch. See [release notes](RELEASE_NOTES_1.0.2.md), [release status](RELEASE_STATUS_1.0.2.md) and [QA matrix](QA_MATRIX_1.0.2.md). The application now identifies itself as `1.0.2`; Windows, Linux and macOS binary packaging must still be separately verified. `Ctrl+Tab` is advertised and confirmed on Windows; the unreliable `Ctrl+Shift+Tab` shortcut is no longer advertised or bound by BetterTTY-specific code. Debian, DMG and Windows portable package scripts now derive versions from the numeric `project(VERSION ...)` field rather than incorrectly falling back to `0.0.0`.


## 1.0.1-dev — internal development checkpoint (not a separate release)

### Implemented — awaiting Windows build and regression verification

- **FR-010 — Keyboard tab navigation:** **Ctrl+Tab** activates the next BetterTTY tab and **Ctrl+Shift+Tab** the previous, with wrap-around and a no-op for a single tab. The **Session** menu exposes both shortcuts. Embedded xterm.js captures the combinations before terminal input and forwards them through Qt WebChannel, so they also work when SSH/Hermes/nano has focus. No connection state is modified. Requires Windows, Linux and macOS manual testing to confirm Qt/WebEngine behavior.

- **FR-009 — Auto Copy on Selection (default On):** A completed mouse selection in the SSH terminal automatically copies plain text to the standard system clipboard. **Tools → Settings → Terminal → Automatically copy selected text** disables only this automatic behavior; right-click **Copy**, toolbar **Copy** and **Ctrl+Shift+C** (also Command+Shift+C in the embedded terminal on macOS) remain available in either state. No clipboard writes during dragging, empty selections or when disabled. Setting is `settings.terminal.copy_on_select` (default `true`, including older configurations missing the key) and updates already-open tabs. Automatic copying replaces prior clipboard contents, which may contain secrets. Windows/macOS/Linux manual testing pending.

- **FR-002 — Development build identification and What's New:** Application/About now report **1.0.1-dev** with codename, milestone and build label (Git short commit plus `-dirty` when built from a modified Git worktree; `source-archive` for a ZIP checkout). Welcome lists the planned 1.0.1 changes. CMake project version is `1.0.1`, with a separate `-dev` suffix, and Windows version resources are generated from the same version fields.
- **FR-004 — Unified terminal Paste and native terminal context menu:** Qt WebEngine's generic editing context menu is replaced for SSH terminal tabs by Copy, Paste, Select All, Clear Terminal. Right-click Paste, **Edit → Paste**, the toolbar Paste button and captured keyboard paste all use `WebTerminalTab::pasteClipboard()`, respecting Automatic / Legacy / Slow and plain text. Note: browser/web-edit "Paste and match style" is removed from the SSH context menu; no rich-text pasting is provided.
- **BUG-005 — Light theme tab close icon:** Explicit light/dark close-button image resources avoid a white/low-contrast glyph disappearing on the active Light tab. Tab close behavior and active-SSH confirmation remain unchanged.
- **BUG-006 — Readable Settings descriptions:** Description labels now use theme-aware selectors rather than an inline `palette(mid)` color: Light labels `#111827`, descriptions `#667085`; Dark labels `#FFFFFF`, descriptions `#B8C0CC`. Applied to every Settings page, including diagnostics.
- **BUG-008 — Settings checkbox visibility in Light theme:** Explicit high-contrast, checked/unchecked/disabled checkbox indicators for Settings in Light and Dark. The change is scoped to `SettingsDialog` rather than application-wide; other dialogs and checkbox semantics are unchanged. Windows visual and keyboard regression tests pending.
- **FR-007 — Light/Dark only:** Removed the System theme option. Light is the default for new users, missing/unknown settings, legacy `system` configs and config recovery; existing `dark` preferences remain unchanged. Loading an old config does not silently rewrite it; saving Settings normalizes it to `light`.
- **BUG-003 / FR-003 — Advanced Paste Modes and TUI multiline compatibility:** Added **Settings → Terminal → Paste mode**: **Automatic** (default, uses the bundled xterm.js Bracketed Paste negotiation when supported), **Legacy** (raw/CR-delimited terminal paste), and **Slow Paste** (paced non-blocking chunks, max 128 UTF-16 code units and one Enter per 50 ms). Removed automatic trailing Enter and the stripping of Bracketed Paste markers. Changes take effect in open and new terminal tabs and persist as `settings.terminal.paste_mode`. Slow Paste does not provide atomic multiline submission and may still execute commands in line-oriented shells. **Windows runtime validation pending.**
- **FR-001 — Optional paste notifications:** **Tools → Settings → Terminal → Show paste notifications** now controls the informational `[BetterTTY] Sent clipboard text to remote shell ...` confirmation. The default is **Off**, including for existing configs. The choice persists in `settings.terminal.show_paste_notifications`, and saving Settings updates already-open xterm.js tabs. Pasting and other terminal notifications are unaffected.

**Validation:** Not yet verified by a Windows build or runtime test; see `docs/TESTCASE_1.0.1.md`. The running application identifies itself as **1.0.1-dev**; **1.0.1** is not released until the full patch is reviewed and verified.

## 1.0.0 — Andromeda

Initial BetterTTY release.

Highlights:

- saved SSH sessions and groups
- password and private-key authentication
- known-host verification with multi-key host entries
- bundled xterm.js terminal renderer
- SSH PTY resize synchronization and terminal lifecycle handling
- native and multiline paste handling
- two-panel SFTP file manager
- queue-first file and folder transfers
- retry and overwrite/skip queue decisions
- queued local/remote delete safety
- config import/export/backup/restore and corrupt-config recovery
- optional diagnostic logging
- combined terminal and SFTP Session Traffic counters
- Linux, Windows, and macOS packaging helpers
- BetterTTY product identity, icon set, application metadata, and documentation
