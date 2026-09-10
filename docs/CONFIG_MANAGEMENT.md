# BetterTTY Config Management

BetterTTY is built around one primary file:

```text
BetterTTY.json
```

This file is intended to be portable, human-readable, and easy to back up.

## Default paths

Linux:

```text
~/.config/DD-LAB/BetterTTY/BetterTTY.json
```

Windows/macOS:

```text
Qt QStandardPaths::AppConfigLocation
```

The exact path is shown in:

```text
Help → About BetterTTY
Tools → Settings
```

## Config folder

Open it from:

```text
File → Open Config Folder
```

## Backups

When enabled in Settings, BetterTTY creates backups before saving.

Backup names look like:

```text
BetterTTY.json.bak-20260517-204435-715
```

Settings:

```text
Tools → Settings → Config safety
```

Options:

```text
Enable config backups before save
Keep last N backups
```

## Export

```text
File → Export Config...
```

Exports the active `BetterTTY.json` to a user-selected path.

Warning: exported configs may contain plaintext passwords and private keys.

## Import

```text
File → Import Config...
```

Import flow:

```text
1. User selects JSON file.
2. BetterTTY validates that it is valid JSON.
3. BetterTTY validates that the root is a JSON object.
4. BetterTTY warns that current sessions/secrets/known_hosts/settings will be replaced.
5. BetterTTY creates a pre-import backup of the active config.
6. BetterTTY copies the imported file as active BetterTTY.json.
7. BetterTTY reloads settings and session list.
```

## Restore latest backup

```text
File → Restore Latest Backup...
```

Restore flow:

```text
1. BetterTTY finds newest valid BetterTTY.json.bak-* file.
2. BetterTTY asks for confirmation.
3. Current active config is moved aside as BetterTTY.json.pre-restore-*.
4. Backup is copied back as BetterTTY.json.
5. Settings and session list reload.
```

## Corrupt config recovery

If active config is invalid, BetterTTY does not overwrite it.

The recovery dialog offers:

```text
Open config folder
Continue read-only
Restore latest valid backup
Create fresh config
```

### Continue read-only

Starts the app with default in-memory settings and an empty session list if needed. Save operations must not silently overwrite the corrupt file.

### Restore latest valid backup

Moves corrupt config aside and restores the latest valid backup.

### Create fresh config

Moves corrupt config aside and creates a new empty default `BetterTTY.json`.

## Manual safety commands

Before risky tests:

```bash
cp ~/.config/DD-LAB/BetterTTY/BetterTTY.json ~/.config/DD-LAB/BetterTTY/BetterTTY.json.manual-good
chmod 600 ~/.config/DD-LAB/BetterTTY/BetterTTY.json.manual-good
```

Validate JSON:

```bash
jq . ~/.config/DD-LAB/BetterTTY/BetterTTY.json >/dev/null && echo "JSON OK"
```

List backups:

```bash
ls -la ~/.config/DD-LAB/BetterTTY/BetterTTY.json*
```

## Import/export safety preview

Starting with `1.0.0`, BetterTTY previews configs before import/export. The preview is informational and does not change the human-readable JSON schema. It shows session count, known-host count, trusted key count, secrets mode, saved secret count, plaintext-secret presence, settings presence, metadata presence, and warnings.

This is intended to make the current `plain-v1` portability model safer without introducing encryption or an opaque config format yet.
