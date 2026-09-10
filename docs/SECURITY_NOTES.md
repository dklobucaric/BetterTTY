# BetterTTY security notes

BetterTTY handles credentials, SSH host keys, terminal sessions, and remote file transfers. Security-sensitive behavior should remain explicit and conservative.

## Secret storage

BetterTTY 1.0.0 supports:

```text
secrets.mode = plain-v1
```

In this mode, saved passwords and private-key contents are human-readable inside `BetterTTY.json` and its backups/exports.

Treat these files as sensitive:

```text
BetterTTY.json
BetterTTY.json.bak-*
BetterTTY.json.pre-import-*
BetterTTY.json.pre-restore-*
BetterTTY.json.corrupt-*
```

Do not commit or share real configs. Use BetterTTY only on trusted machines while `plain-v1` storage is enabled.

## Host-key verification

Host-key verification occurs before SSH authentication. Unknown keys require an explicit decision. Changed keys must not be silently trusted.

BetterTTY can store multiple valid host-key algorithms for the same `host:port`, allowing a portable config to work across platforms that negotiate different legitimate algorithms.

## Config recovery

If the active JSON config is invalid or not a JSON object, BetterTTY refuses to silently overwrite it. Recovery actions preserve the damaged file whenever possible and support restoring a valid backup.

## Logging privacy

Diagnostic logging is disabled by default.

Logs may contain troubleshooting metadata such as host, port, username, authentication method, host-key type/fingerprint, transfer paths, sizes, decisions, and result states.

Logs must never contain:

- passwords
- private-key contents
- plaintext secret values
- terminal input or terminal output
- clipboard contents
- file contents
- complete `BetterTTY.json` content

Platform log locations use the DD-LAB / BetterTTY application identity. The exact path is available from **Help → Open Log Folder** and the About dialog.

## SFTP safety

File transfers use libssh SFTP APIs. Destructive local/remote delete operations are queued and explicitly confirmed when execution reaches the delete item.

## Future hardening

Encrypted/master-password-backed credential storage is a future roadmap item. It is not part of BetterTTY 1.0.0.
