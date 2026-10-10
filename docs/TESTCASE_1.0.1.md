# BetterTTY 1.0.1 — Windows patch regression checklist

This checklist is for **development** fixes added after the 1.0.0 baseline. A checked box must represent an actual Windows runtime test, not code inspection. Also run the existing `docs/TESTCASE_1.0.md` and relevant `docs/TEST_MATRIX.md` checks before release.

## FR-001 — Paste notifications (default OFF)

- [ ] Compile the project on Windows (Qt6, MSVC, libssh) and launch BetterTTY.
- [ ] With an existing 1.0.0 `BetterTTY.json` that does **not** contain `settings.terminal.show_paste_notifications`, open **Tools → Settings → Terminal** and confirm **Show paste notifications** is unchecked.
- [ ] Paste nonempty single-line clipboard text using the terminal **Paste** button; remote shell receives the original input, but the `[BetterTTY] Sent clipboard text ...` informational line does not appear.
- [ ] Paste using Ctrl+Shift+V and native/right-click paste; confirm input still reaches the remote shell without the informational line.
- [ ] Paste multiline text with each of the 3 modes; verify no paste confirmation when checkbox is Off (new default behavior no longer adds a trailing Enter).
- [ ] Enable **Show paste notifications** and click **OK**; paste in the **same already-open terminal tab** and confirm the existing confirmation appears with character/line counts.
- [ ] Open a **new** terminal tab and verify the enabled setting applies there, too.
- [ ] Restart BetterTTY and check **Show paste notifications** stays enabled and messages continue to appear.
- [ ] Disable **Show paste notifications**, click **OK**, and verify the information line disappears in both already-open and new terminal tabs.
- [ ] Restart BetterTTY and verify **Off** remains saved in `BetterTTY.json` (`settings.terminal.show_paste_notifications = false`).
- [ ] Confirm that other informational and error messages (SSH disconnects, empty clipboard, failed connections) are **not** silenced by this option.
- [ ] Press **Cancel** after changing the checkbox and confirm the previous saved preference remains in effect.
- [ ] Review the Settings save/import/export/backup paths to ensure the new boolean survives round trips without losing unrelated config fields.

**Status: all tests pending (not executed in this source-only environment).**

## BUG-003 / FR-003 — Advanced Paste Modes and multiline TUI compatibility

- [ ] Open **Tools → Settings → Terminal** and confirm **Paste mode** has exactly **Automatic (recommended)**, **Legacy**, and **Slow Paste (compatibility)**, with **Automatic** selected for existing 1.0.0 configs.
- [ ] Change to each mode, save, reopen Settings and restart BetterTTY; confirm `settings.terminal.paste_mode` persists (`automatic`, `legacy`, `slow`) and existing open terminal tabs immediately use the new mode.
- [ ] With **Automatic** and Hermes TUI running, paste 10 lines using toolbar Paste, Ctrl+Shift+V and right-click native paste; verify all 10 lines arrive together as a single input block (if Hermes supports Bracketed Paste).
- [ ] With **Automatic** and nano, paste multiline YAML/config text including blank lines and non-ASCII characters; verify no missing/reordered lines.
- [ ] In a plain shell without Bracketed Paste, compare Automatic and Legacy: a multiline paste may execute commands. Do NOT test with destructive commands.
- [ ] In all modes paste `echo first\necho last` **without** a trailing newline, verify **last line is not automatically executed**; repeat with a trailing newline to confirm it is preserved.
- [ ] With **Legacy**, repeat 10-line paste into an interactive prompt; verify conventional Enter behavior is maintained (no Bracketed Paste framing).
- [ ] With **Slow Paste**, paste >100 short lines and a single line >512 characters; verify all characters arrive, with pauses and no added final Enter.
- [ ] With **Slow Paste**, begin pasting a long harmless text and press a key/Ctrl+C while in progress; verify unsent chunks are cancelled, manual input remains responsive, and no data continues after cancellation.
- [ ] With **Slow Paste**, repeat the test with an emoji or supplementary-plane UTF-8 character near a 128-character chunk boundary; verify no corrupted glyphs.
- [ ] With **Slow Paste**, disconnect/reconnect or switch paste mode during the transfer; verify the old queued input is cancelled.
- [ ] Toggle **Show paste notifications** and verify status lines are hidden by default; when enabled, Slow Paste only reports after queueing all chunks.
- [ ] Verify copy, Ctrl+C interrupt, terminal Reset, PTY resize, and reconnection are unaffected.
- [ ] Confirm behavior when bundled xterm.js assets are unavailable (fallback renderer); Automatic must fall back to plain input without injecting raw bracket markers.

**Status: all Windows tests pending.** No source-only check is a substitute for Hermes/nano/shell runtime verification.

## FR-002 — Build identity and Welcome

- [ ] Build on Windows from a clean directory and check Help → About reports **1.0.1-dev**, codename **Andromeda**, milestone and **Build** field.
- [ ] Check Windows File Explorer → BetterTTY.exe → Properties → Details. File/Product versions are consistent with **1.0.1-dev** (numeric Windows version 1.0.1.0).
- [ ] Confirm the Welcome tab shows **What's New & Bugfixes** and all in-scope change IDs; it is explicitly labeled as a development build.
- [ ] If building from a Git checkout, verify About Build matches the short commit, with `-dirty` when changed; from a ZIP, verify `source-archive`.

## FR-004 — Unified context-menu Paste

- [ ] On a connected SSH terminal right-click in the xterm area: only terminal actions **Copy**, **Paste**, **Select All**, **Clear Terminal** should appear, not Chromium Undo/Redo or Paste and match style.
- [ ] Paste the identical ten-line Hermes payload using right-click, **Edit → Paste**, toolbar Paste, Ctrl+Shift+V and native Ctrl+V; in Automatic mode each is one multiline prompt when negotiated by Hermes.
- [ ] Repeat with Legacy and Slow Paste and verify mode selection applies to every entry point; no unsolicited trailing Enter.
- [ ] Copy selected terminal text, Select All, and Clear Terminal; ensure Clear only clears local view, not remote shell.
- [ ] Verify right-click Paste is disabled when SSH disconnected, and Edit → Paste does not act on the Welcome or SFTP tab.
- [ ] Re-test fallback terminal renderer and macOS Command+V where available.

## BUG-005 and BUG-006 — Theme/Settings contrast

- [ ] In **Light**, open multiple tabs and switch selection: every active/inactive tab shows a dark visible X, including with mouse hover and Windows 125%/150% scaling.
- [ ] In **Dark**, X remains white/visible on all tabs; clicking an X on a connected terminal still prompts to disconnect; No keeps connection open.
- [ ] In all six Settings pages, Light option labels are dark and descriptions gray; Dark option labels are white and descriptions light gray.
- [ ] In Diagnostics, header description and checkbox help are readable; inspect Security note, disabled fields, warning text and focus/selection states.

## BUG-008 — Settings checkbox visibility (Light and Dark)

- [ ] Open **Tools → Settings → Diagnostics** with the Light theme. The **unchecked** diagnostic-logging box must have a clearly visible dark outline on its white background.
- [ ] Check **Enable diagnostic logging**: a clear checkmark must appear. Uncheck it and confirm the border stays visible; press **Cancel** to avoid enabling logging unintentionally.
- [ ] Repeat **checked/unchecked** states for the checkboxes on **General**, **Terminal** and **Config safety** pages.
- [ ] Switch to Dark, reopen Settings and repeat. The checkbox border and checkmark must remain distinguishable; verify labels and descriptions remain readable.
- [ ] Test keyboard navigation (Tab/Space), Windows 100%/125%/150% scaling, and an app restart. Confirm checkbox click targets and actual saved settings have not changed.
- [ ] Check unrelated confirmation/connect dialogs to confirm their native checkbox styling is unaffected.

**Status: Windows runtime verification pending; checkbox bitmaps and stylesheet references were inspected only.**

## FR-007 — Light/Dark only and migration

- [ ] On clean config, Light is enabled by default. Settings → Appearance has exactly **Light** and **Dark**, with no System option.
- [ ] Set Dark, save and restart, verify Dark persists and all Settings descriptions remain legible.
- [ ] Use a safe backup of an old 1.0.0 config with `"app_theme": "system"`; verify Light is used. Without saving Settings, verify original JSON remains unchanged; after Save, it contains `"light"`.
- [ ] Verify an existing config with `"app_theme": "dark"` stays Dark across startup and config import/restore.
- [ ] Trigger config recovery using a disposable test config (never overwrite your only real configuration) and verify the recovery UI uses the Light theme.

**Windows compilation and the new UI regression scenarios above have not been executed in this environment.**

## FR-009 — Copy on Selection (default On)

- [ ] On a fresh configuration and on an older one missing `copy_on_select`, the **Automatically copy selected text** Settings checkbox is checked by default. Existing explicit `false` stays Off.
- [ ] In an SSH terminal, highlight 10 Hermes/SSH log lines with a mouse and release. Alt+Tab to an editor and Ctrl+V: the entire selection appears (including Unicode, blank lines and indent) without manually choosing Copy.
- [ ] Double-click a word and triple-click a line if xterm supports it; paste the expected selected text. During dragging, no intermediate selection must replace the OS clipboard.
- [ ] Clicking without selecting, clicking another UI widget or right-clicking alone must not erase/replace the clipboard.
- [ ] Set Auto Copy Off and Save. In already-open and new terminal tabs, highlighting text leaves the clipboard unchanged. Right-click **Copy** and the toolbar **Copy** still copy successfully.
- [ ] With Auto Copy Off then On, select text and press **Ctrl+Shift+C**: manual Copy works in both states. Plain **Ctrl+C** must still send a remote interrupt.
- [ ] All three paste modes (Automatic, Legacy, Slow) must continue to work independently of Copy setting.
- [ ] Restart, verify saved setting, and test a disposable legacy config missing the key. The On default must not rewrite JSON until the next explicit save.
- [ ] Repeat on Windows 11, macOS (including Command+Shift+C) and Linux (X11/Wayland): copy goes into the standard OS clipboard, not only an X11 PRIMARY selection. Test Hermes mouse-reporting mode, and fallback terminal renderer.
- [ ] Be aware of clipboard history/cloud synchronization: selecting secret text may expose it to clipboard managers. Avoid copying secrets during validation.

**FR-009 Windows/macOS/Linux runtime tests pending.**

## FR-010 — Keyboard tab navigation

- [ ] Open Welcome, two independent SSH terminals, and an SFTP tab. With focus inside an **SSH xterm.js** terminal (Hermes/nano/shell), press **Ctrl+Tab** repeatedly. The selection must move in visual tab order, wrapping from last to first. No Tab character is sent to remote software.
- [ ] **Ctrl+Shift+Tab** is not a supported BetterTTY reverse-navigation shortcut in 1.0.2 (was unreliable on Windows).
- [ ] Focus Welcome, SFTP file manager, and session sidebar; verify the two shortcuts work via Qt as well as in WebEngine.
- [ ] Use **Session → Next Tab**; it must match Ctrl+Tab. No Previous Tab menu is advertised.
- [ ] Leave only one tab open and press either shortcut: no error or accidental closure.
- [ ] After switching back to an SSH terminal, type a harmless command and verify keyboard focus/input remains usable; confirm no SSH disconnect/reconnect and no lost SFTP state.
- [ ] Verify existing shortcuts still work: Ctrl+C remote interrupt, Ctrl+Shift+C Copy, Ctrl+Shift+V Paste, regular Tab in shell (completion), and Ctrl+Tab in embedded terminal does not type a literal tab remotely.
- [ ] Test Windows 11 with Qt WebEngine, macOS, Linux, and xterm.js fallback. Manual cross-platform checks are pending; JavaScript-level simulation cannot establish native focus/shortcut dispatch correctness.
