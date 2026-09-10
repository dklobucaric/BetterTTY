# BetterTTY 1.0.0 — Andromeda

**A better way to SSH.**  
*Your servers. One dock.*

BetterTTY 1.0.0 is the first public BetterTTY release: a cross-platform SSH client, session manager, and SFTP file manager built with Qt 6, C++, libssh, and xterm.js.

## Highlights

- saved SSH sessions with grouping
- password and private-key authentication
- host-key verification before authentication
- xterm.js SSH terminal tabs with PTY resize synchronization
- two-panel local/remote SFTP file manager
- queue-first upload/download and recursive folder queueing
- transfer retry and overwrite/skip controls
- queued delete with destructive-operation confirmation
- config backup, restore, import/export, and recovery tools
- optional diagnostic logging
- live terminal and SFTP traffic counters

## Security note

BetterTTY 1.0.0 supports `plain-v1` secret storage in `BetterTTY.json`. Secret values are human-readable. Keep configuration files private and use this mode only on trusted machines.

## Known limits

Sync/mirror, partial-transfer resume, parallel transfers, recursive non-empty-directory delete, rename, chmod/chown, metadata preservation, and symlink following during recursive transfer are not included in 1.0.0.

## Project

Website: https://bettertty.dev  
License: MIT  
Copyright: © 2026 Dalibor Klobučarić
