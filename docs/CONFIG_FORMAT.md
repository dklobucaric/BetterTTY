# BetterTTY Config Format

BetterTTY uses one primary JSON config file:

```text
BetterTTY.json
```

Linux default path:

```text
~/.config/DD-LAB/BetterTTY/BetterTTY.json
```

Windows and macOS use Qt's platform-specific application config location through `QStandardPaths::AppConfigLocation`.

## Top-level structure

```json
{
  "app": {},
  "settings": {},
  "groups": [],
  "sessions": [],
  "known_hosts": {},
  "secrets": {},
  "metadata": {}
}
```

## Example

```json
{
  "app": {
    "name": "BetterTTY",
    "config_version": 1
  },
  "settings": {
    "appearance": {
      "app_theme": "light"
    },
    "terminal": {
      "font_family": "monospace",
      "font_size": 14,
      "show_paste_notifications": false,
      "copy_on_select": true,
      "paste_mode": "automatic"
    },
    "config_safety": {
      "backups_enabled": true,
      "max_backups": 10
    },
    "behavior": {
      "double_click_action": "open_terminal",
      "show_quick_toolbar": false
    }
  },
  "groups": [],
  "sessions": [
    {
      "id": "root-192-168-1-237-223",
      "name": "Local test server",
      "group": "Lab",
      "host": "192.168.1.237",
      "port": 223,
      "username": "root",
      "auth": {
        "type": "password",
        "secret_ref": "secret-root-192-168-1-237-223-password"
      }
    }
  ],
  "known_hosts": {
    "192.168.1.237:223": {
      "keys": {
        "ssh-ed25519": "SHA256:example-ed25519",
        "ecdsa-sha2-nistp256": "SHA256:example-ecdsa"
      },
      "first_seen": "2026-05-17T12:00:00Z",
      "last_seen": "2026-05-17T12:30:00Z"
    }
  },
  "secrets": {
    "mode": "plain-v1",
    "items": {
      "secret-root-192-168-1-237-223-password": {
        "type": "password",
        "value": "plaintext-password"
      }
    }
  },
  "metadata": {
    "created_by": "BetterTTY"
  }
}
```

## Settings

### Appearance

```json
"appearance": {
  "app_theme": "light"
}
```

Supported values:

```text
light
dark
```

Default: `light`. Old or unknown values (including `system` from 1.0.0) load as `light`; `dark` is preserved. Opening a legacy config does not rewrite the file, but saving Settings persists the normalized theme. This affects the Qt UI only; the xterm.js terminal theme remains dark.

### Terminal

```json
"terminal": {
  "font_family": "monospace",
  "font_size": 14,
  "show_paste_notifications": false,
  "copy_on_select": true,
  "paste_mode": "automatic"
}
```

Terminal font settings apply to newly opened xterm.js tabs.

`paste_mode` is `"automatic"` by default (also for existing configs missing the key). Supported values: `"automatic"`, `"legacy"`, `"slow"`. Unknown values fall back safely to `"automatic"`. **Automatic** uses xterm.js's Bracketed Paste negotiation, **Legacy** sends plain CR-delimited input, and **Slow Paste** sends legacy input in timed chunks (50 ms). Unlike earlier behavior, pasting will not synthesize a final Enter. Changing the preference in Settings updates already-open terminals.

`show_paste_notifications` is a boolean and defaults to `false`, **including for existing 1.0.0 configs that do not have this key**. When `false`, BetterTTY still pastes clipboard text into the remote shell but suppresses only the informational `Sent clipboard text to remote shell` message. When `true`, that confirmation appears as it did in 1.0.0. Saving Settings updates existing and new terminal tabs immediately.

`copy_on_select` is a boolean and defaults to `true`, including older configs missing this key. When enabled, completing a mouse selection in an SSH terminal copies plain text to the standard system clipboard. When disabled, selecting text does not update the clipboard, but right-click Copy, toolbar Copy and Ctrl+Shift+C still work. Saving the setting updates existing tabs. Auto Copy replaces previous clipboard contents (including potentially sensitive values).

### Config safety

```json
"config_safety": {
  "backups_enabled": true,
  "max_backups": 10
}
```

When enabled, BetterTTY creates rotating `BetterTTY.json.bak-*` backups before saves.

### Behavior

```json
"behavior": {
  "double_click_action": "open_terminal",
  "show_quick_toolbar": false
}
```

`double_click_action` is currently expected to be `open_terminal`.

## Known hosts

Starting with `1.0.0`, BetterTTY stores known hosts as **multiple trusted host keys per `host:port`**. This is required for one portable `BetterTTY.json` to work across platforms because different libssh/OS combinations may negotiate different legitimate server host-key algorithms.

Current format:

```json
"known_hosts": {
  "138.2.166.222:223": {
    "keys": {
      "ssh-ed25519": "SHA256:b2bVKCQSkPXuvXn4blGPV91iuJ5ySA8PqrBsI/8i5hs",
      "ecdsa-sha2-nistp256": "SHA256:tXwRSs3yDB71wdVX8Cnj57dmCszCgtU1kIHnDS9i19w"
    },
    "first_seen": "2026-05-20T20:00:00Z",
    "last_seen": "2026-05-20T20:30:00Z"
  }
}
```

Legacy format is still accepted and migrated on save:

```json
"known_hosts": {
  "138.2.166.222:223": {
    "algorithm": "ssh-ed25519",
    "fingerprint": "SHA256:b2bVKCQSkPXuvXn4blGPV91iuJ5ySA8PqrBsI/8i5hs"
  }
}
```

Decision rules:

- no entry for `host:port` → unknown host prompt
- same key type and same fingerprint → trusted
- new key type for an already-known `host:port` → **Trust additional key** prompt
- same key type but different fingerprint → strong **SSH host key changed** warning

## Sessions

A session describes a connection target and auth method.

Password session:

```json
{
  "id": "server-1",
  "name": "Server 1",
  "group": "Lab",
  "host": "192.168.1.237",
  "port": 223,
  "username": "root",
  "auth": {
    "type": "password",
    "secret_ref": "secret-server-1-password"
  }
}
```

Private-key session:

```json
{
  "id": "server-key",
  "name": "Server Key",
  "group": "Lab",
  "host": "192.168.1.222",
  "port": 223,
  "username": "root",
  "auth": {
    "type": "key",
    "key_ref": "secret-server-key"
  }
}
```

## Secrets

Early BetterTTY builds use:

```json
"secrets": {
  "mode": "plain-v1",
  "items": {}
}
```

Password secret:

```json
"secret-server-password": {
  "type": "password",
  "value": "plaintext-password"
}
```

Private-key secret:

```json
"secret-server-key": {
  "type": "private_key",
  "value": "-----BEGIN OPENSSH PRIVATE KEY-----\n...\n-----END OPENSSH PRIVATE KEY-----\n"
}
```

Sessions reference secrets. Secrets are not stored directly inside the session object.

This is intentional because future encrypted storage can replace the `secrets` backend without changing saved session structure.

## known_hosts

Known-host records are stored separately from sessions.

Deleting a session does not automatically delete `known_hosts`.

Reason: several sessions may point to the same host/port with different usernames or auth methods.

## Import/export behavior

Import/export operates on the whole config file.

Import replaces:

```text
sessions
secrets
known_hosts
settings
metadata
```

Before import, BetterTTY creates a pre-import backup of the active config.

## Corrupt config behavior

If `BetterTTY.json` is invalid JSON or not a JSON object, BetterTTY refuses to overwrite it automatically.

Recovery options:

```text
Continue read-only
Restore latest valid backup
Create fresh config
Open config folder
```

Corrupt files are preserved as:

```text
BetterTTY.json.corrupt-<timestamp>
```
