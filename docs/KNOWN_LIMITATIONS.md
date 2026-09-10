# BetterTTY known limitations

BetterTTY 1.0.0 — Andromeda is a usable first release, but several areas remain intentionally conservative.

## Secret storage

`plain-v1` passwords and private keys in `BetterTTY.json` are human-readable. Keep the config and its backups private and use this storage mode only on trusted machines.

## SFTP file manager

BetterTTY 1.0.0 does not yet implement:

- sync or mirror mode
- partial-transfer resume
- parallel transfers
- recursive deletion of non-empty directories
- rename, chmod, or chown
- preservation of permissions and timestamps during transfer
- symlink following during recursive folder transfer
- OS-wide/global traffic monitoring

SFTP upload/download bytes are included in the Session Traffic widget. Directory listing, mkdir, and delete operations are not counted as bulk transfer traffic.

## Transfer model

The queue executes one transfer item at a time. This prioritizes predictable behavior and clear overwrite/delete decisions over maximum throughput.

## Platform packaging

- Linux packaging expects distribution-provided Qt/libssh runtime dependencies.
- Windows standalone packaging uses `windeployqt` plus required libssh/vcpkg DLLs.
- macOS packaging helpers can create local `.app`/`.dmg` builds; signing/notarization is a separate release responsibility.
- Microsoft Store packaging is planned for a follow-up BetterTTY release and is not part of the 1.0.0 source package.
