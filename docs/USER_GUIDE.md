# BetterTTY User Guide

## Main window

BetterTTY uses a simple layout:

```text
Left side: saved sessions from BetterTTY.json
Right side: terminal tabs
Bottom: status bar
```

Double-click a saved session to open the default xterm.js terminal.

## Menus

### File

Config-level and app-level actions.

```text
Open Config Folder
Export Config...
Import Config...
Restore Latest Backup...
Exit
```

### Session

SSH session workflow actions.

```text
New Session
Connect / Auth test
Edit selected session
```

### Tools

Utility and app configuration actions.

```text
Multi-Exec (placeholder for future work)
Settings
```

### Help

```text
About BetterTTY
```

## Session workflows

### New Session

Creates a saved session after successful authentication.

Use this when adding a server you want to keep.

BetterTTY intentionally saves a new session only after the SSH handshake, known-host decision, and authentication test succeed. If the connection/authentication fails, the session is not saved. This keeps `BetterTTY.json` from filling with broken or unverified connection profiles.

### Connect / Auth test

Runs a manual connection/authentication test. Saving is optional.

Use this when testing credentials, host keys, ports, or temporary access.

### Edit selected session

Edits the currently selected sidebar session.

For password/private-key secrets:

```text
Leave password/key empty to keep the existing saved secret.
Enter a new password/key to replace the saved secret.
```

## Exit safety

If you close BetterTTY while one or more terminal tabs are still connected, the app asks before disconnecting them.

This applies to:

```text
Window close button / X
File → Exit
```

If you choose `Cancel`, BetterTTY stays open and all sessions remain connected.

If you choose `Disconnect and Exit`, BetterTTY requests disconnect on the active terminal sessions and then closes.

## Sidebar context menu

Right-click a saved session:

```text
Open xterm.js terminal
Run auth test
Open basic shell fallback
Edit session
Delete session
```

The basic shell fallback is a debug/development fallback. The normal terminal is xterm.js.

## Terminal tabs

The xterm.js terminal supports:

- Direct keyboard input
- Paste (Automatic / Legacy / Slow Paste via Settings → Terminal)
- Ctrl+C
- PTY resize sync
- Full-screen terminal apps such as `htop`, `nano`, `vim`, `top`
- Reconnect after disconnect

Terminal buttons:

```text
Ctrl+C     Send interrupt to remote shell
Paste      Send clipboard text to terminal
Clear      Clear local terminal view
Reset      Reset local xterm renderer state
Focus      Focus terminal area
Reconnect  Reconnect after disconnect
Disconnect Disconnect SSH shell
```

### Paste modes (1.0.1 development)

Use **Tools → Settings → Terminal → Paste mode**:

- **Automatic (default):** uses Bracketed Paste when the remote application requests it, through xterm.js; otherwise regular paste. Recommended for Hermes and modern TUI apps.
- **Legacy:** sends plain CR-delimited text; copied line breaks may act as Enter.
- **Slow Paste:** sends plain text in bounded pieces, separated by 50 ms timer intervals. Typing a key or disconnecting cancels the remainder; the mode cannot guarantee a single logical submission in Hermes.

Pasting never inserts an extra final Enter that was not in the clipboard. These settings apply to open terminal tabs as soon as Settings are saved. The separate **Show paste notifications** checkbox controls only the confirmation text, not the paste mode.

## Terminal lifecycle

When the remote shell exits, server reboots, or SSH transport drops, BetterTTY marks the tab disconnected and disables remote input actions.

After disconnect, use:

```text
Reconnect
```

The reconnect action uses the same saved session and plaintext secret.

## Settings

Open:

```text
Tools → Settings
```

### General

- Config path display
- Open config folder
- Double-click session action display
- Show quick action toolbar

### Appearance

- Light (default)
- Dark

Old `system` settings from 1.0.0 are interpreted as Light; existing Dark settings stay Dark.

This changes the Qt application chrome only. The xterm.js terminal theme remains dark for now.

### Terminal

- Font family
- Font size
- Show paste notifications (Off by default)
- Paste mode: Automatic (default), Legacy or Slow Paste
- Automatically copy selected text (On by default): completing a mouse selection copies SSH terminal text into the system clipboard. Turn Off to use manual Copy; right-click Copy, toolbar Copy and Ctrl+Shift+C always stay available. Selection may overwrite sensitive existing clipboard content.

Terminal right-click uses Copy, Paste, Select All and Clear Terminal. Paste through the context menu, Edit menu, toolbar or keyboard follows the selected paste mode; rich-text formatting is not supported.

Font settings apply to newly opened xterm.js terminal tabs. Existing terminal tabs are not changed live yet.

### Config safety

- Enable config backups before save
- Keep last N backups

## Config import/export

### Export Config

Copies the active `BetterTTY.json` to a user-selected path.

Warning: exported configs may contain plaintext passwords and private keys.

### Import Config

Validates a selected JSON file, warns, creates a backup of the current active config, then replaces the active config.

Import replaces:

```text
sessions
secrets
known_hosts
settings
metadata
```

### Restore Latest Backup

Restores the newest valid `BetterTTY.json.bak-*` file from the config folder.

The previous active config is moved aside as:

```text
BetterTTY.json.pre-restore-<timestamp>
```
