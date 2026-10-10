# BetterTTY features

BetterTTY 1.0.0 — Andromeda combines SSH session management, a real terminal, and an SFTP file manager in one cross-platform desktop application.

## Saved sessions

- saved server profiles with optional groups
- password or private-key authentication
- session create/edit/delete workflows
- duplicate `username@host:port` warning
- save-after-successful-authentication behavior
- one human-readable `BetterTTY.json` configuration file

## Host verification

- host-key verification before authentication
- unknown/changed-host decision flow
- multiple trusted host-key algorithms per `host:port`
- portable known-host records stored with the application config

## Terminal

- bundled xterm.js renderer through Qt WebEngine
- no runtime CDN requirement for terminal assets
- SSH PTY resize synchronization
- terminal lifecycle and disconnect handling
- Ctrl+C remote interrupt
- Auto Copy on Selection (default On; optional, preserves right-click Copy and Ctrl+Shift+C) — in 1.0.1 development
- toolbar, context-menu, keyboard, and macOS paste routing
- multiline paste handling suitable for terminal editors and config files
- tested full-screen applications including `htop`, `nano`, `vim`, `top`, and `clear`

## SFTP file manager

- two-panel local/remote view
- libssh SFTP browsing rather than shell-command parsing
- upload and download queue
- recursive folder scan-to-queue workflow
- sequential transfer execution
- progress, speed, elapsed-time, and completion feedback
- overwrite / skip / overwrite-all / skip-all decisions
- retry selected for eligible finished queue items
- queued local and remote delete with explicit destructive confirmation
- local/remote refresh after queue runs

## Session traffic

- live SSH terminal traffic counters
- SFTP upload/download byte counters
- session-level status-bar visibility

## Config and settings

- config preview and recovery
- rotating backups
- import/export
- restore latest valid backup
- theme selection
- terminal font settings
- selectable terminal paste modes: Automatic (negotiated Bracketed Paste), Legacy (plain CR), Slow Paste (paced chunks) — in 1.0.1 development
- quick toolbar visibility
- optional diagnostic logging

## Packaging

- Linux release build helper
- Debian package helper
- Windows standalone deployment helper
- Windows portable ZIP helper
- macOS `.app`/`.dmg` deployment helper
- SHA-256 checksum helpers

## Security model in 1.0.0

BetterTTY supports `plain-v1` secret storage for portability. Passwords/private keys stored in this mode are human-readable inside `BetterTTY.json`. Keep the config private and use this mode only on trusted machines.

See `SECURITY_NOTES.md` and `KNOWN_LIMITATIONS.md`.
